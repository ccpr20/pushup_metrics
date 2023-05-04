class Reminder < ActiveRecord::Base
	belongs_to :user
	phony_normalize :phone_number, default_country_code: 'US'
	after_create :send_welcome_text, if: -> { Rails.env.production? }

	validates_presence_of :phone_number

	# rake task for generic 3:30p PST reminders
	def self.send_reminders
    unless is_weekend?
      send_sms_reminders
      send_slack_reminders
    end
	end

	# rake task for custom user reminders
	def self.send_reminders_v2
    unless is_weekend?
      send_custom_sms_reminders
    end
	end

	# generic afternoon reminder
	def self.get_users_with_reminders
		# don't text people at generic fixed time if they have a custom time pref
		all_reminders = Reminder.where('time' => nil).where('time_zone' => nil).where.not('phone_number' => nil)
		all_reminders.map {|reminder| reminder.phone_number}
	end

	def self.send_sms_reminders
    users = get_users_with_reminders
		RemindersJob.perform_async(users)
	end

	# for sharing new features - change which reminders to fetch based on need
	# def send_sms_feature_update(users)
	# 	client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
	#
	# 	users.each do |user|
	# 	  client.messages.create(
	# 	    from: ENV['TWILIO_PHONE_NUMBER'],
	# 	    to: user,
	# 	    body: "[[NEW FEATURE GOES HERE]]")
	# 	end
	# end

	def self.send_slack_reminders
		location = ask_the_weather
    Galvanize.ping "@channel All right maggots, hit the #{location} and give me some pushups!" unless is_weekend?
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

		# TODO: include last couple hours because recent rain == wet roof
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
	      body: 'Welcome to pelo Metrics! Text this number or +1(877)-554-4582 at any time with a minutes count for instant logging. (To set your preferences, log in and click the Reminders tab in pelometrics.io .)')
		end
  end

	# v2.0, considers user timezone and time of day preferences
	def self.send_custom_sms_reminders
		client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		users = get_reminders_and_preferences
		selected_users = parse_current_reminders(users)
		message = create_reminder_message
		unless selected_users.empty? # kill process if no reminders to send
			selected_users.each do |user|
	      client.messages.create(
	        from: ENV['TWILIO_PHONE_NUMBER'],
	        to: user[:phone_number],
	        body: message
	      )
			end
		end
	end

	# lookup user timezone and time preferences
	def self.get_reminders_and_preferences
    all_reminders = Reminder.where.not('time' => nil).where.not('time_zone' => nil) # only retrieve users with custom prefs
    all_reminders.map {|r| {phone_number: r['phone_number'], time: r['time'], time_zone: r['time_zone']}}
	end

	def self.parse_current_reminders(users)
		reminders_to_send = []

		users.each do |user|
			reminder = set_in_timezone(user[:time], user[:time_zone])
			reminders_to_send << user if remind_now?(reminder)
		end

		reminders_to_send # return only those people needing a text now (10 min cron schedule)
	end

	# convert user's reminder time-of-day and their timezone into UTC,
	# for scheduler rake task reminders
	def self.set_in_timezone(time, zone)
	  Time.use_zone(zone) { time.to_datetime.change(offset: Time.zone.now.strftime("%z")) }
	end

	def self.remind_now?(reminder) # reminder should be the reformatted UTC time
		current_hour = Time.now.utc.hour
		current_minute = Time.now.utc.min

		reminder_hour = reminder.utc.hour
		reminder_minute = reminder.utc.min

		# TODO: account for hour mark breakpoints, ie 10:55 --> 11:05, which should work but doesn't
		current_hour == reminder_hour && ((current_minute - reminder_minute) <= 10 && (current_minute - reminder_minute) > 0)
	end

	def self.create_reminder_message
		message = [
			"Drop down and give me some minutes, maggot!",
			"Pain is temporary, pride is forever.",
			"Sweat is your fat crying.",
			"Everything is hard before it is easy.",
			"Excuses don't burn calories.",
			"Make today's workout tomorrow's warmup.",
			"Change doesn't happen over night.  Be patient.",
			"Working out is a reward, not a punishment.",
			"Work hard now, selfie later.",
			"Did you log Pelo minutes today? "
		].sample
		message + " (Reply with your number in minutes to log your activity today.)"
	end

end
