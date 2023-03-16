require File.expand_path('../boot', __FILE__)
require 'rails/all'
require 'mixpanel-ruby'

Bundler.require(*Rails.groups)
Browser::Base.include(Browser::Aliases) # Configure browser gem to include aliases (i.e. mobile?)

module Speedrail
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    # config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

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
