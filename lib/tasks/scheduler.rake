desc "Reminder tasks"
task :sms_pushup_reminder => :environment do
  Reminder.send_reminders
  puts "Reminders sent!"
end
