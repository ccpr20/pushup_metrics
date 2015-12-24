class Reminder < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id
	phony_normalize :phone_number, default_country_code: 'US'

	def self.send_reminders
	  client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		# todo: iterate through all phone numbers on platform
		users = get_users_with_reminders
		users.each do |user|
			client.messages.create(
			    from: ENV['TWILIO_PHONE_NUMBER'],
			    to: user,
			    body: 'Drop down and give me some pushups, maggot! Then reply to this message with the amount you did for instant logging.')
		end
	end

	def self.get_users_with_reminders(arr=[])
		all_reminders = Reminder.all
		all_reminders.each do |reminder|
			arr << reminder.phone_number
		end
		arr.uniq! # in case a user provided their phone multiple times, don't spam
	end

end
