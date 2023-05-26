class RemindersJob
  include SuckerPunch::Job

  def perform(users)
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    ActiveRecord::Base.connection_pool.with_connection do
      users.each do |user|
        client.messages.create(
          from: ENV['TWILIO_PHONE_NUMBER'],
          to: user,
          body: 'Drop down and give me some pushups (Reply to this message with an amount for instant logging.)')
        puts "texted: #{user}"
      end
    end
  end

end
