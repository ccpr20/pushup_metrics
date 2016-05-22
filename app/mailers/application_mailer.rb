class ApplicationMailer < ActionMailer::Base
  default from: "'Pushup Metrics' <digest@pushupmetrics.com>"
  layout 'mailer'
end
