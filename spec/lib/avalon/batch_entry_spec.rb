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

describe Avalon::Batch::Entry do

  RSpec::Matchers.define :hash_match do |expected|
    match do |actual|
      diff = HashDiff.diff(actual,expected) do |p,a,e|
        if a.is_a?(RealFile) && e.is_a?(RealFile)
          FileUtils.cmp(a,e)
        elsif a.is_a?(File) && e.is_a?(File)
          FileUtils.cmp(a,e)
        elsif p == ""
           nil
        else
          a.eql? e
        end
      end
      diff == []
    end
  end

  let(:testdir) {'spec/fixtures/dropbox/dynamic'}
  let(:filename) {File.join(testdir,'video.mp4')}
  let(:collection) {FactoryGirl.create(:collection)}
  let(:manifest) do
    manifest = double()
    allow(manifest).to receive_message_chain(:package, :dir).and_return(testdir)
    allow(manifest).to receive_message_chain(:package, :user, :user_key).and_return('archivist1@example.org')
    allow(manifest).to receive_message_chain(:package, :collection).and_return(collection)
    manifest
  end
  let(:entry_fields) do
    { title: Faker::Lorem.sentence,
      topical_subject: 'This and that',
      language: 'eng',
      genre: 'Aviation',
      date_issued: "#{Time.now.to_date}",
    }
  end
  let(:entry) do
    Avalon::Batch::Entry.
      new(entry_fields, [{file: filename, skip_transcoding: false}], {},
          nil, manifest)
  end

  describe "update" do
    let(:media_object) { FactoryGirl.create(:media_object,
                                            title: 'Before update') }
    let(:update_fields) do
      { title: 'After update', media_object: [media_object.pid] }
    end

    let(:entry) { Avalon::Batch::Entry.new(update_fields, [], {}, nil, manifest) }

    it "should update the object" do
      expect(media_object.title).to eq('Before update')
      entry.process!
      media_object.reload
      expect(media_object.title).to eq('After update')
    end

    it "should only update fields it's told to update" do
      media_object.update_datastream(:descMetadata, {topical_subject: ["Won't Change"] })
      media_object.save
      expect(media_object.title).to eq('Before update')
      expect(media_object.topical_subject).to eq(["Won't Change"])
      entry.process!
      media_object.reload
      expect(media_object.title).to eq('After update')
      puts media_object.inspect
      expect(media_object.topical_subject).to eq(["Won't Change"])
    end

    let(:bad_entry) do
      Avalon::Batch::Entry.
        new(entry_fields, [{file: filename, skip_transcoding: false}], {},
            nil, manifest)
    end

    it "should be invalid when both media object and files present" do
      expect(bad_entry.valid?).to be_falsy
    end
  end

  before(:each) do
    #FakeFS.activate!
    #FakeFS::FileSystem.clone(File.join(Rails.root, "config"))
    FileUtils.mkdir_p(testdir)
    FileUtils.touch(filename)
  end

  after(:each) do
    FileUtils.rm(filename)
    FileUtils.rmdir(testdir)
    #FakeFS.deactivate!
  end

  describe '#file_valid?' do
    it 'should be valid if the file exists' do
      expect(entry.file_valid?({file: filename})).to be_truthy
      expect(entry.errors).to be_empty
    end 
    it 'should be valid if masterfile exists and it is not skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return([])
      expect(entry.file_valid?({file: filename, skip_transcoding: false})).to be_truthy
      expect(entry.errors).to be_empty
    end 
    it 'should be valid if masterfile exists and it is skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return([])
      expect(entry.file_valid?({file: filename, skip_transcoding: true})).to be_truthy
      expect(entry.errors).to be_empty
    end 
    it 'should be invalid if pretranscoded derivatives exist and it is not skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return(['derivative.low.mp4', 'derivative.medium.mp4', 'derivative.high.mp4'])
      expect(entry.file_valid?({file: 'derivative.mp4', skip_transcoding: false})).to be_falsey
      expect(entry.errors).not_to be_empty
    end 
    it 'should be valid if pretranscoded derivatives exist and it is skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return(['derivative.low.mp4', 'derivative.medium.mp4', 'derivative.high.mp4'])
      expect(entry.file_valid?({file: 'derivative.mp4', skip_transcoding: true})).to be_truthy
      expect(entry.errors).to be_empty
    end 
    it 'should be invalid if neither the file nor derivatives exist - not skip transcode' do
      expect(entry.file_valid?({file: 'nonexistent.mp4', skip_transcoding: false})).to be_falsey
      expect(entry.errors).not_to be_empty
    end
    it 'should be invalid if neither the file nor derivatives exist - skip transcode' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return([])
      expect(entry.file_valid?({file: 'derivative.mp4', skip_transcoding: true})).to be_falsey
      expect(entry.errors).not_to be_empty
    end
    it 'should be invalid if both file and derivatives exist and it is not skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return(['video.low.mp4', 'video.medium.mp4', 'video.high.mp4'])
      expect(entry.file_valid?({file: filename, skip_transcoding: false})).to be_falsey
      expect(entry.errors).not_to be_empty
    end 
    it 'should be invalid if both file and derivatives exist and it is skip-transcoding' do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).and_return(['video.low.mp4', 'video.medium.mp4', 'video.high.mp4'])
      expect(entry.file_valid?({file: filename, skip_transcoding: true})).to be_falsey
      expect(entry.errors).not_to be_empty
    end 
  end

  describe '#valid?' do
    it "should be valid under the right conditions" do
      allow(entry).to receive(:file_valid?).and_return(true)
      allow(entry.media_object).to receive(:valid?).and_return(true)
      expect(entry.valid?).to be_truthy
    end

    it "should not be valid when the media object is not valid" do
      media_object_error = { some_field: [ 'Some error' ] }
      allow(entry).to receive(:file_valid?).and_return(true)
      allow(entry.media_object).to receive(:valid?).and_return(false)
      allow(entry.media_object.errors).to receive(:messages).
        and_return(media_object_error)
      expect(entry.valid?).to be_falsey
      expect(entry.errors.messages).to eq(media_object_error)
    end

    let(:no_collection_entry) do
      Avalon::Batch::Entry.
        new( {collection: ['bad_collection']}, [{file: filename, skip_transcoding: false}],
             {}, nil, manifest)
    end
    it "should not be valid when the media object has no collection" do
      allow(no_collection_entry).to receive(:file_valid?).and_return(true)
      allow(no_collection_entry.media_object).to receive(:valid?).and_return(true)
      allow(no_collection_entry.media_object).to receive(:collection).and_return(nil)
      expect(no_collection_entry.valid?).to be_falsey
      expect(no_collection_entry.errors.messages.keys).to eq([:collection])
      expect(no_collection_entry.errors.messages[:collection]).
        to eq(["Collection not found: bad_collection"])
    end

    it "should be not valid when there are no valid files" do
      allow(entry).to receive(:file_valid?).and_return(false)
      allow(entry.media_object).to receive(:valid?).and_return(true)
      expect(entry.valid?).to be_falsey
      expect(entry.errors.messages.keys).to eq([:content])
      expect(entry.errors.messages[:content]).to eq(["No files listed"])
    end

    it "should not be valid when a file isn't valid" do
      allow(entry.media_object).to receive(:valid?).and_return(true)
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).
        and_return(['video.low.mp4', 'video.medium.mp4', 'video.high.mp4'])
      expect(entry.valid?).to be_falsey
      expect(entry.errors.messages.keys).to eq([:content])
      expect(entry.errors.messages[:content]).
        to eq(["Derivative files found but skip transcoding not selected",
               "No files listed"])
    end

    let(:media_object) { FactoryGirl.create(:media_object,
                                            title: 'Before update') }
    let(:update_entry) do
      Avalon::Batch::Entry.
        new({ title: 'New title', media_object: [media_object.pid] }, [], {},
            nil, manifest)
    end
    it "update entry should be valid under the right conditions" do
      expect(update_entry.valid?).to be_truthy
      expect(update_entry.errors.messages.keys).to eq([])
    end

    let(:bad_update_entry) do
      Avalon::Batch::Entry.
        new({ title: 'New title', media_object: [media_object.pid] }, 
            [{file: filename, skip_transcoding: true}], {}, nil, manifest)
    end

    it "it should not be valid when both a media object and a file are present" do
      allow(Avalon::Batch::Entry).to receive(:derivativePaths).
        and_return(['video.low.mp4', 'video.medium.mp4', 'video.high.mp4'])
      expect(bad_update_entry.valid?).to be_falsey
      expect(bad_update_entry.errors.messages.keys).to eq([:content])
      expect(bad_update_entry.errors.messages[:content]).
        to eq(["Both a metadata update, and files listed for processing! "\
               "(Must be one or the other)"])
    end
  end

  describe '#gatherFiles' do
    it 'should return a file when no pretranscoded derivatives exist' do      
      expect(FileUtils.cmp(Avalon::Batch::Entry.gatherFiles(filename), filename)).to be_truthy
    end
  end

  describe 'with multiple pretranscoded derivatives' do
    let(:filename) {'videoshort.mp4'}
    %w(low medium high).each do |quality|
      let("filename_#{quality}".to_sym) {"videoshort.#{quality}.mp4"}
    end
    let(:derivative_paths) {[filename_low, filename_medium, filename_high]}
    let(:derivative_hash) {{'quality-low' => File.new(filename_low), 'quality-medium' => File.new(filename_medium), 'quality-high' => File.new(filename_high)}}


    before(:each) do
      derivative_paths.each {|path| FileUtils.touch(path)}
    end

    after(:each) do
      derivative_paths.each {|path| FileUtils.rm(path)}      
    end

    describe '#process' do
      let(:entry) do
        Avalon::Batch::Entry.
          new(entry_fields, [{file: filename, skip_transcoding: true}], {},
              nil, manifest)
      end

      before(:each) do
        derivative_paths.each {|path| FileUtils.touch(File.join(testdir,path))}
      end
      after(:each) do
        derivative_paths.each {|path| FileUtils.rm(File.join(testdir,path))}
      end

      it 'should call MasterFile.setContent with a hash or derivatives' do
        allow_any_instance_of(MasterFile).to receive(:file_format).and_return('Moving image')
        expect_any_instance_of(MasterFile).to receive(:setContent).
          with(hash_match(derivative_hash))
        expect_any_instance_of(MasterFile).to receive(:process).
          with(hash_match(derivative_hash))
        entry.process!
      end
    end

    describe '#gatherFiles' do
      it 'should return a hash of files keyed with their quality' do
        expect(Avalon::Batch::Entry.gatherFiles(filename)).to hash_match derivative_hash
      end
    end

    describe '#derivativePaths' do
      it 'should return the paths to all derivative files that exist' do
        expect(Avalon::Batch::Entry.derivativePaths(filename)).to eq derivative_paths
      end
    end

    describe '#derivativePath' do
      it 'should insert supplied quality into filename' do
        expect(Avalon::Batch::Entry.derivativePath(filename, 'low')).to eq filename_low
      end
    end

    describe 'required fields' do
      let(:entry) do
        Avalon::Batch::Entry.
          new(entry_fields, [{file: filename, skip_transcoding: true}], {},
              nil, manifest)
      end
      let(:entry_no_language) do
        Avalon::Batch::Entry.
          new(entry_fields.except(:language), [{file: filename, skip_transcoding: true}], {},
              nil, manifest)
      end
      let(:entry_no_topical_subject) do
        Avalon::Batch::Entry.
          new(entry_fields.except(:topical_subject),
              [{file: filename, skip_transcoding: true}], {},
              nil, manifest)
      end
      let(:entry_no_genre) do
        Avalon::Batch::Entry.
          new(entry_fields.except(:genre),
              [{file: filename, skip_transcoding: true}], {},
              nil, manifest)
      end
      before(:each) do
        derivative_paths.each {|path| FileUtils.touch(File.join(testdir,path))}
      end
      after(:each) do
        derivative_paths.each {|path| FileUtils.rm(File.join(testdir,path))}
      end

      it 'should pass when required fields present' do
        entry.valid?
        expect(entry_no_language.errors.empty?).
          to be_truthy
      end

      it 'should fail when no language' do
        entry_no_language.valid?
        expect(entry_no_language.errors.messages.keys).
          to eq([:language])
        expect(entry_no_language.errors.messages[:language]).
          to eq(["field is required."])
      end
      
      it 'should fail when no topical subject' do
        entry_no_topical_subject.valid?
        expect(entry_no_topical_subject.errors.messages.keys).
          to eq([:topical_subject])
        expect(entry_no_topical_subject.errors.messages[:topical_subject]).
          to eq(["field is required."])
      end
      it 'should fail when no genre' do
        entry_no_genre.valid?
        expect(entry_no_genre.errors.messages.keys).
          to eq([:genre])
        expect(entry_no_genre.errors.messages[:genre]).
          to eq(["At least one genre must be specified"])
      end
    end

  end
end
