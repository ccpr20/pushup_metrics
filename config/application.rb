require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Speedrail
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    ActionMailer::Base.smtp_settings = {
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :domain => 'freelancedebt.com',
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }

  end
end
