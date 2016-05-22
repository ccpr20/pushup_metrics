class WeeklyDigest < ApplicationMailer

  def send_records(recipient, records)
    @recipient_name = recipient.name.split[0].strip
    @records = records
    mail(to: recipient.email, subject: 'Your weekly metrics are here.')
  end

end
