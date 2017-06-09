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
require 'fakefs/safe'

describe AvalonJobs do

  context "fakefs" do

    before :each do
      @oldpath = "/path/to/old/file.mp4"
      @mf = FactoryGirl.build(:master_file)
      @mf.file_location = @oldpath
      @mf.save
      FakeFS.activate!
      FileUtils.mkdir_p File.dirname(@oldpath)
      File.open(@oldpath, 'w'){}
    end

    describe "delete_masterfile" do
      it "should delete masterfile" do
        AvalonJobs.delete_masterfile_without_delay @mf.pid
        expect(File.exists? @oldpath).to be false
        expect(MasterFile.find(@mf.pid).file_location).to be_blank
      end
    end

    describe "move_masterfile" do
      it "should move masterfile" do
        newpath = "/path/to/new/file.mp4"
        AvalonJobs.move_masterfile_without_delay @mf.pid, newpath
        expect(File.exists? @oldpath).to be false
        expect(File.exists? newpath).to be true
        expect(newpath).to eq MasterFile.find(@mf.pid).file_location
      end
    end

    after :each do 
      FakeFS.deactivate!
    end
  end

  describe "collection_batch_ingest" do
    it "should launch a batch ingest for a collection" do
      collection = FactoryGirl.create(:collection)
      ingest = double('ingest').as_null_object
      allow(Avalon::Batch::Ingest).to receive(:new).and_return(ingest)
      allow(ingest).to receive(:ingest)

      expect(ingest).to receive(:ingest)

      AvalonJobs.collection_batch_ingest_without_delay collection.pid
    end
  end
end
