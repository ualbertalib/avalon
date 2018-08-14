require 'rails_helper'

describe 'AuditObjectsMailer' do

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe '#error_report' do
    before(:each) do
      # Fake MediaObject with errors
      @media_object =
        instance_double('MediaObject',
                        id: 'avalon:1111',
                        class: 'MediaObject')
      allow(@media_object).to receive(:errors) {
        double('media_object_errors', full_messages: ['One message', 'Two message'])
      }
      allow(@media_object).to receive(:collection) {
        double('media_object_collection', id: 'avalon:333', name: 'Some Collection')
      }

      # Fake MasterFile with errors
      @master_file = instance_double('MasterFile',
                                     id: 'avalon:2222',
                                     class: 'MasterFile')
      allow(@master_file).to receive(:errors) {
        double('master_file_errors', full_messages: ['Three message', 'Four message'])
      }
      @bad_objects = [@media_object, @master_file]

      # Fake stats
      @stats = [ { heading: 'Total', value: 2 },
                 { heading: 'Whatever', value: 'Some bogus stat' } ]
    end
    let (:email) { AuditObjectsMailer.error_report(@bad_objects, @stats) }

    it 'has correct e-mail address' do
      expect(email).to deliver_to('avalon-errors@example.edu')
    end

    it 'has correct subject' do
      expect(email).to have_subject('ERA A+V Object Errors')
    end

    it 'has object names and error messages in body' do
      expect(email)
        .to have_body_text(/MediaObject: avalon:1111.*One message.*Two message/m)
      expect(email)
        .to have_body_text(/MasterFile: avalon:2222.*Three message.*Four message/m)
    end

    it 'has collection name for MediaObject in body' do
      expect(email)
        .to have_body_text(/MediaObject: avalon:1111.*Collection:.*Some Collection/m)
    end


    it 'has stats in body' do
      expect(email).to have_body_text(/Stats.*Total.*2.*Whatever.*Some bogus stat/m)
    end

  end
end
