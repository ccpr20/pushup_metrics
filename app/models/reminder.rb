class Reminder < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id
	phony_normalize :phone_number, default_country_code: 'US'

	def self.send_reminders
        unless is_weekend?  
          client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
          send_sms_reminders(client)
          send_slack_reminders
        end
	end

	def self.get_users_with_reminders
        all_reminders = Reminder.all
        all_reminders.map {|reminder| reminder.phone_number}
	end

	def self.send_sms_reminders(client)
	      users = get_users_with_reminders
		users.each do |user|
              client.messages.create(
                from: ENV['TWILIO_PHONE_NUMBER'],
                to: user,
                body: 'Drop down and give me some pushups, maggot! (Reply to this message with an amount for instant logging.)')
		end
	end

	def self.send_slack_reminders
        #todo: refactor for WYSIWYG team config
        SlackBot.ping '@channel All right maggots, hit the roof and give me some pushups!'  unless is_weekend?
	end

    def self.is_weekend?
      today = Date.today.strftime('%a')
      today == "Sat" || today == "Sun"
    end
end
