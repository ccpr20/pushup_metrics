require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'mixpanel-ruby'

Bundler.require(*Rails.groups)
Browser::Base.include(Browser::Aliases) # Configure browser gem to include aliases (i.e. mobile?)

module Speedrail
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    ActionMailer::Base.smtp_settings = {
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :domain => 'www.pushupmetrics.com',
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }

  end
end
