# Copyright 2011-2015, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

require 'spec_helper'
require 'avalon/dropbox'
require 'avalon/batch/ingest'
require 'fileutils'

describe Avalon::Batch::Ingest do

  before :each do
    allow(Avalon::Configuration).to receive(:lookup).and_call_original
    allow(Avalon::Configuration).to receive(:lookup)
      .with('dropbox.path').and_return('spec/fixtures/dropbox')
    allow(Avalon::Configuration).to receive(:lookup)
      .with('email.notification').and_return('frances.dickens@reichel.com')
    # Dirty hack is to remove the .processed files both before and after the
    # test. Need to look closer into the ideal timing for where this should take
    # place
    # this file is created to signify that the file has been processed
    # we need to remove it so can re-run the tests
    Dir['spec/fixtures/**/*.xlsx.process*',
        'spec/fixtures/**/*.xlsx.error',
        'spec/fixtures/**/*.xlsx.log'].each { |file| File.delete(file) }

    User.create(:username => 'frances.dickens@reichel.com', :email => 'frances.dickens@reichel.com')
    User.create(:username => 'jay@krajcik.org', :email => 'jay@krajcik.org')
    RoleControls.add_user_role('frances.dickens@reichel.com','manager')
    RoleControls.add_user_role('jay@krajcik.org','manager')
    allow_any_instance_of(Avalon::Batch::Manifest).to receive_message_chain(:manifest_logger, :info)
    allow_any_instance_of(Avalon::Batch::Manifest).to receive_message_chain(:manifest_logger, :error)
  end

  after :each do
    Dir['spec/fixtures/**/*.xlsx.process*',
        'spec/fixtures/**/*.xlsx.error',
        'spec/fixtures/**/*.xlsx.log'].each { |file| File.delete(file) }
    RoleControls.remove_user_role('frances.dickens@reichel.com','manager')
    RoleControls.remove_user_role('jay@krajcik.org','manager')
    
    # this is a test environment, we don't want to kick off
    # generation jobs if possible
    allow_any_instance_of(MasterFile).to receive(:save).and_return(true)
  end

  describe 'valid manifest' do
    let(:collection) { FactoryGirl.create(:collection, name: 'Ut minus ut accusantium odio autem odit.', managers: ['frances.dickens@reichel.com']) }
    let(:batch_ingest) { Avalon::Batch::Ingest.new(collection) }
    let(:bib_id) { '7763100' }
    let(:sru_url) { "http://zgate.example.edu:9000/db?version=1.1&operation=searchRetrieve&maximumRecords=1&recordSchema=marcxml&query=rec.id=#{bib_id}" }
    let(:sru_response) { File.read(File.expand_path("../../../fixtures/#{bib_id}.xml",__FILE__)) }
    
    before :each do
      @dropbox_dir = collection.dropbox.base_directory
      FileUtils.cp_r 'spec/fixtures/dropbox/example_batch_ingest', @dropbox_dir
      allow(Avalon::Configuration).to receive(:lookup).with('bib_retriever')
        .and_return({ 'protocol' => 'sru', 'url' => 'http://zgate.example.edu:9000/db' })
      FakeWeb.register_uri :get, sru_url, body: sru_response
      manifest_file = File.join(@dropbox_dir,'example_batch_ingest','batch_manifest.xlsx')
      batch = Avalon::Batch::Package.new(manifest_file, collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
    end

    after :each do
      if @dropbox_dir =~ %r{spec/fixtures/dropbox/Ut} 
        FileUtils.rm_rf @dropbox_dir
      end
      FakeWeb.clean_registry
    end

    it 'should send email when batch finishes processing' do
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_success).with(duck_type(:each)).and_return(mailer)
      expect(mailer).to receive(:deliver)
      batch_ingest.ingest
    end
    
    it 'should skip the corrupt manifest' do
      manifest_file = File.join(@dropbox_dir,'example_batch_ingest','bad_manifest.xlsx')
      batch = Avalon::Batch::Package.new(manifest_file, collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      expect { batch_ingest.ingest }.not_to raise_error
      expect { batch_ingest.ingest }.not_to change{IngestBatch.count}
      error_file = File.join(@dropbox_dir,'example_batch_ingest','bad_manifest.xlsx.error')
      expect(File.exists?(error_file)).to be true
      expect(File.read(error_file)).to match(/^Invalid manifest/)
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with(/Invalid manifest/).once
    end
    
    it 'should ingest batch with spaces in name' do
      space_batch_path = File.join('spec/fixtures/dropbox/example batch ingest', 'batch manifest with spaces.xlsx')
      space_batch = Avalon::Batch::Package.new(space_batch_path, collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [space_batch]
      expect{batch_ingest.ingest}.to change{IngestBatch.count}.by(1)
    end

    it 'should ingest batch with skip-transcoding derivatives' do
      derivatives_batch_path = File.join('spec/fixtures/dropbox/pretranscoded_batch_ingest', 'batch_manifest_derivatives.xlsx')
      derivatives_batch = Avalon::Batch::Package.new(derivatives_batch_path, collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [derivatives_batch]
      expect_any_instance_of(MasterFile).to receive(:process).with(hash_including('quality-high', 'quality-medium', 'quality-low'))
      expect{batch_ingest.ingest}.to change{IngestBatch.count}.by(1)
    end
 
    it 'creates an ingest batch object' do
      expect{batch_ingest.ingest}.to change{IngestBatch.count}.by(1)
    end

    it 'should update objects' do
      update_batch_path =
        File.join('spec/fixtures/dropbox/example_batch_ingest',
                  'batch_update_manifest.xlsx')
      update_batch = Avalon::Batch::Package.new(update_batch_path, collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [update_batch]
      media_objects = 
        [ FactoryGirl.create(:media_object,
                             title: "Title 1 before",
                             creator: ['Before, John']),
          FactoryGirl.create(:media_object,
                             title: "Title 2 before",
                             creator: ['Before, Jane']),
          FactoryGirl.create(:media_object,
                             title: "Title 3",
                             creator: ['Before, Jim']) ]
      allow(MediaObject).to receive(:find).and_call_original
      allow(MediaObject).to receive(:find).with("avalon:21").
        and_return(media_objects[0])
      allow(MediaObject).to receive(:find).with("avalon:22").
        and_return(media_objects[1])
      allow(MediaObject).to receive(:find).with("avalon:23").
        and_return(media_objects[2])

      batch_ingest.ingest

      expect(media_objects[0].creator).to eq(['After, Jane'])
      expect(media_objects[0].title).to eq('Title 1 before')

      expect(media_objects[1].creator).to eq(['Update, Jimmy'])
      expect(media_objects[1].title).to eq('The Title After')

      expect(media_objects[2].bibliographic_id).to eq(['local', bib_id])
      expect(media_objects[2].creator).to eq(['111 A C D E F G K L N P Q T'])
      expect(media_objects[2].title).to eq('245 A : B F G K N P S')
    end
 
    it 'should retrieve bib data' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.first
      media_object = MediaObject.find(ingest_batch.media_object_ids.last)
      expect(media_object.bibliographic_id).to eq(['local', bib_id])
      expect(media_object.title).to eq('245 A : B F G K N P S')
    end
    
    it 'should ingest structural metadata' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.first
      media_object = MediaObject.find(ingest_batch.media_object_ids.first)
      master_file = media_object.parts.first
      expect(master_file.structuralMetadata.has_content?).to be_truthy
    end

    it 'should ingest captions' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.first
      media_object = MediaObject.find(ingest_batch.media_object_ids.first)
      master_file = media_object.parts.first
      expect(master_file.captions.has_content?).to be_truthy
    end

    it 'should set MasterFile details' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.last
      media_object = MediaObject.find(ingest_batch.media_object_ids.first) 
      master_file = media_object.parts.first
      expect(master_file.label).to eq('Quis quo')
      expect(master_file.poster_offset.to_i).to eq(500)
      expect(master_file.workflow_name).to eq('avalon')
      expect(master_file.absolute_location).to eq(Avalon::FileResolver.new.path_to(master_file.file_location)) 
      expect(master_file.date_digitized).to eq('2015-10-30T00:00:00Z')
      # if a master file is saved on a media object 
      # it should have workflow name set
      # master_file.workflow_name.should be_nil

      master_file = media_object.parts[1]
      expect(master_file.label).to eq('Unde aliquid')
      expect(master_file.poster_offset.to_i).to eq(500)
      expect(master_file.workflow_name).to eq('avalon-skip-transcoding')
      expect(master_file.absolute_location).to eq('file:///tmp/sheephead_mountain_master.mov')
      expect(master_file.date_digitized).to eq('2015-10-31T00:00:00Z')

      master_file = media_object.parts[2]
      expect(master_file.label).to eq('Audio')
      expect(master_file.workflow_name).to eq('fullaudio')
      expect(master_file.absolute_location).to eq(Avalon::FileResolver.new.path_to(master_file.file_location))
    end

    it 'should set avalon_uploader' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.last
      media_object = MediaObject.find(ingest_batch.media_object_ids.first)
      expect(media_object.avalon_uploader).to eq('frances.dickens@reichel.com')
    end

    it 'should set hidden' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.last
      media_object = MediaObject.find(ingest_batch.media_object_ids.first)
      expect(media_object).not_to be_hidden

      media_object = MediaObject.find(ingest_batch.media_object_ids[1])
      expect(media_object).to be_hidden
    end

    it 'should correctly set identifiers' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.last
      media_object = MediaObject.find(ingest_batch.media_object_ids.last)
      expect(media_object.bibliographic_id).to eq(["local",bib_id])
    end

    it 'should correctly set notes' do
      batch_ingest.ingest
      ingest_batch = IngestBatch.last
      media_object = MediaObject.find(ingest_batch.media_object_ids.first)
      expect(media_object.note.first).to eq(["general","This is a test general note"])
    end

  end

  describe 'invalid manifest' do
    let(:collection) { FactoryGirl.create(:collection, name: 'Ut minus ut accusantium odio autem odit.', managers: ['frances.dickens@reichel.com']) }
    let(:batch_ingest) { Avalon::Batch::Ingest.new(collection) }
    let(:dropbox) { collection.dropbox }

    before :each do
      @dropbox_dir = collection.dropbox.base_directory
    end

    after :each do
      if @dropbox_dir =~ %r{spec/fixtures/dropbox/Ut} 
        FileUtils.rm_rf @dropbox_dir
      end
    end

    it 'does not create an ingest batch object when there are zero packages' do
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return []
      #expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(anything(), include("Expected error message"))
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
    end

    it 'should result in an error if a file is not found' do
      batch = Avalon::Batch::Package.new( 'spec/fixtures/dropbox/example_batch_ingest/wrong_filename_manifest.xlsx', collection )

      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(duck_type(:each),duck_type(:each)).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
      expect(batch.errors[3].messages).to have_key(:content)
      expect(batch.errors[3].messages[:content]).to eq(["File not found: spec/fixtures/dropbox/example_batch_ingest/assets/sheephead_mountain_wrong.mov"])

      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with("Row 3:\n  Content File not found: "\
              'spec/fixtures/dropbox/example_batch_ingest/'\
              'assets/sheephead_mountain_wrong.mov').once
    end

    it 'does not create an ingest batch object when there are no files' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/no_files.xlsx', collection)

      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}

      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with("Row 3:\n  Content No files listed").once
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with("Row 4:\n  Content No files listed").once
    end

    it 'should fail if the manifest specified a non-manager user' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/non_manager_manifest.xlsx', collection)

      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(anything(), include("User jay@krajcik.org does not have permission to add items to collection: Ut minus ut accusantium odio autem odit..")).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with('User jay@krajcik.org does not have permission to add items to collection: '\
              'Ut minus ut accusantium odio autem odit..').once
    end

    it 'should fail if a bad offset is specified' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/bad_offset_manifest.xlsx', collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(duck_type(:each),duck_type(:each)).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
      expect(batch.errors[4].messages).to have_key(:offset)
      expect(batch.errors[4].messages[:offset]).to eq(['Invalid offset: 5:000'])
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with(/Row 4:\n  Offset Invalid offset: 5:000/).once
    end

    it 'should fail if missing required field' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/missing_required_field.xlsx', collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(duck_type(:each),duck_type(:each)).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
      expect(batch.errors[4].messages).to have_key(:title)
      expect(batch.errors[4].messages[:title]).to eq(['field is required.'])
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with(/Row 3:\n  Date issued field is required/).once
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with(/Row 4:\n  Title field is required/).once
    end

    it 'should fail if field is not in accepted metadata field list' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/badColumnName_nonRequired.xlsx', collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).with(duck_type(:each),duck_type(:each)).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect{batch_ingest.ingest}.to_not change{IngestBatch.count}
      expect(batch.errors[4].messages).to have_key(:contributator)
      expect(batch.errors[4].messages[:contributator]).to eq(["Metadata attribute 'contributator' not found"])
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with(/Row 3:\n  Contributator Metadata attribute 'contributator' not found/).once
    end
    
    it 'should fail if an unknown error occurs' do
      batch = Avalon::Batch::Package.new('spec/fixtures/dropbox/example_batch_ingest/badColumnName_nonRequired.xlsx', collection)
      allow_any_instance_of(Avalon::Dropbox).to receive(:find_new_packages).and_return [batch]
      mailer = double('mailer').as_null_object
      expect(IngestBatchMailer).to receive(:batch_ingest_validation_error).
        with(batch, [/^RuntimeError: Foo: /]).and_return(mailer)
      expect(mailer).to receive(:deliver)
      expect(batch_ingest).to receive(:ingest_package) { raise "Foo" }
      expect { batch_ingest.ingest }.to_not raise_error
      expect(batch.manifest.manifest_logger).to have_received(:error)
        .with('Unknown error with ingest').once
    end
  end

  it "should be able to default to public access" do
    skip "[VOV-1348] Wait until implemented"
  end

  it "should be able to default to specific groups" do
    skip "[VOV-1348] Wait until implemented"
  end

  describe "#offset_valid?" do
    it {expect(Avalon::Batch::Entry.offset_valid?("33.12345")).to be true}
    it {expect(Avalon::Batch::Entry.offset_valid?("21:33.12345")).to be true}
    it {expect(Avalon::Batch::Entry.offset_valid?("125:21:33.12345")).to be true}
    it {expect(Avalon::Batch::Entry.offset_valid?("63.12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?("66:33.12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?(".12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?(":.12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?(":33.12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?(":66:33.12345")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?("5:000")).to be false}
    it {expect(Avalon::Batch::Entry.offset_valid?("`5.000")).to be false}
  end
end
