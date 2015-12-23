class Reminder < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id
	phony_normalize :phone_number, default_country_code: 'US'

	def self.send_reminders
	  client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		# todo: iterate through all phone numbers on platform
		client.messages.create(
		    from: ENV['TWILIO_PHONE_NUMBER'],
		    to: '+16784317729', # hard code burner number to test task
		    body: 'Drop down and give me pushups, maggot! Log at pushupmetrics.com')
	end

end
