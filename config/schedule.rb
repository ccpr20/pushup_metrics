require "tzinfo"
require 'twilio-ruby'

def local(time)
  TZInfo::Timezone.get("US/Eastern").local_to_utc(Time.parse(time))
end

# eventual implementation
# every 1.day, at: local('15:30 pm') do

every 1.minute do
	runner "Reminder.send_reminders", :environment => 'development'
end
