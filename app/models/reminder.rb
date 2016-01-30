class Reminder < ActiveRecord::Base
	belongs_to :user
	phony_normalize :phone_number, default_country_code: 'US'
	after_create :send_welcome_text

	# rake task
	def self.send_reminders
    unless is_weekend?
      client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      send_sms_reminders(client)
      send_slack_reminders
    end
	end

	# rake task
	def self.send_reminders_v2
    unless is_weekend?
      send_custom_sms_reminders
    end
	end

	# generic afternoon reminder
	def self.get_users_with_reminders
    all_reminders = Reminder.all

		# below check for nil? -- don't text people at fixed time if they have a custom time set
    return all_reminders.map {|reminder| reminder.phone_number if r.time.nil?}
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
		location = ask_the_weather
    SlackBot.ping "@channel All right maggots, hit the #{location} and give me some pushups!"  unless is_weekend?
	end

  def self.is_weekend?
    today = Date.today.strftime('%a')
    today == "Sat" || today == "Sun"
  end

	def self.ask_the_weather
		lat = ENV['GALVANIZE_SF_LAT']
		lon = ENV['GALVANIZE_SF_LON']
		weather = ForecastIO.forecast(lat, lon)['currently']
		forecast = weather.icon.downcase + weather.summary.downcase

		# todo: include last couple hours because recent rain == wet roof
		if forecast.include?('rain') || weather.temperature < 48
			return "BASEMENT"
		else
			return "ROOF"
		end
	end

  def send_welcome_text
		if self.phone_number.present?
	    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
	    client.messages.create(
	      from: ENV['TWILIO_PHONE_NUMBER'],
	      to: self.phone_number,
	      body: 'Welcome to Pushup Metrics! Text this number at any time with your latest pushup count for instant logging.')
		else
			self.destroy # devise reg new action creates blank reminder if no phone provided, remove that here
		end
  end

	# v2.0, considers user timezone and time of day preferences
	def self.send_custom_sms_reminders
		client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		users = get_reminders_and_preferences
		selected_users = parse_current_reminders(users)

		unless selected_users.empty? # kill process if no reminders to send
			selected_users.each do |user|
	      client.messages.create(
	        from: ENV['TWILIO_PHONE_NUMBER'],
	        to: user[:phone],
	        body: 'Drop down and give me some pushups, maggot! (Reply to this message with an amount for instant logging.)')
			end
		end
	end

	# receives user timezone and time preferences
	def self.get_reminders_and_preferences
    all_reminders = Reminder.all
    all_reminders.map {|r| {phone: r['phone_number'], time: r['time'], time_zone: r['time_zone']}}
	end

	def self.parse_current_reminders(users)
		reminders_to_send = []

		users.each do |user|
			reminder = set_in_timezone(user[:time], user[:time_zone])
			reminders_to_send << user if remind_now?(reminder)
		end
		reminders_to_send # return only those people needing a text now (10 min cron schedule)
	end

	# convert user's reminder time-of-day and their timezone into UTC, for scheduler rake task reminders
	def self.set_in_timezone(time, zone)
	  Time.use_zone(zone) { time.to_datetime.change(offset: Time.zone.now.strftime("%z")) }
	end

	def self.remind_now?(reminder) # reminder should be the reformatted UTC time
		current_hour = Time.now.utc.hour
		current_minute = Time.now.utc.min

		reminder_hour = reminder.utc.hour
		reminder_minute = reminder.utc.min

		# todo: account for hour mark breakpoints, ie 10:55 --> 11:05, which should work
		current_hour == reminder_hour && ((current_minute - reminder_minute) <= 10 && (current_minute - reminder_minute) > 0)
	end

end
