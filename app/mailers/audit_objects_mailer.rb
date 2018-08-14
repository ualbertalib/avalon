# Send report of invalid objects to admin team
class AuditObjectsMailer < ApplicationMailer

  def error_report(bad_objects, stats)
    @bad_objects = bad_objects
    @stats = stats
    @email = Settings.email.errors
    mail(to: @email,
         subject: I18n.t('audit.error_report_subject'))
  end

end
