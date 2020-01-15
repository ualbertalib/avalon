require 'rails_helper'
require 'avalon/audit_objects'

describe Avalon::AuditObjects do
  let(:media_object) { FactoryBot.create(:media_object) }

  before(:each) do
    allow(AuditObjectsMailer).to receive(:error_report) {
      double('audit_objects_mailer', deliver_now: nil )
    }
  end

  let(:media_object) { FactoryBot.create(:media_object) }
  let(:master_file) { FactoryBot.create(:master_file) }

  describe '#run' do
    it 'sends no report when everything is valid' do
      Avalon::AuditObjects.run
      expect(AuditObjectsMailer).to_not have_received(:error_report)
    end

    it 'reports invalid objects' do
      media_object.genre = []
      media_object.workflow.last_completed_step='file-upload'
      media_object.save(validate: false)
      master_file.workflow_name = nil
      master_file.save(validate: false)
      Avalon::AuditObjects.run
      expect(AuditObjectsMailer).to have_received(:error_report)
        .with([media_object, master_file],
              [{ heading: I18n.t('audit.total_header_html'), value: 2 },
               { heading: I18n.t('audit.class_total_header_html',
                                 class: MediaObject.name),
                 value: 1 },
               { heading: I18n.t('audit.class_total_header_html',
                                 class: MasterFile.name),
                 value: 1 },
               { heading: I18n.t('audit.collection_total_header_html',
                                 collection: media_object.collection.name),
                 value: 1 }])
    end

  end
end
