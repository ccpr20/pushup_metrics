task :sms_pushup_reminder => :environment do
  Reminder.send_reminders
  puts "Reminders sent!"
end

task :sms_pushup_reminder_v2 => :environment do
  Reminder.send_reminders_v2
  puts "Custom reminders sent!"
end

task :weekly_digest_email => :environment do
  if Time.new.wday == 6 # if today is friday PST (saturday UTC)
    WeeklyDigestJob.perform_async
    puts "Weekly Digest sent!"
  end
end
