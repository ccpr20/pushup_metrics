class RemindersJob
  include SuckerPunch::Job

  def perform(users)
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    users.each do |user|
      client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: user,
        body: 'Drop down and give me some pushups, maggot! (Reply to this message with an amount for instant logging.)')
      puts "texted: #{user}"
    end
  end
end
