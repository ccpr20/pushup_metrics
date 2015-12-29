class TwilioController < ApplicationController
	skip_before_filter  :verify_authenticity_token # ignore CSRF exception block

  def process_sms
		# todo: ignore message and skip operation if phone_number does not exist

		# find user with matching phone number
		reminder = Reminder.find_by(:phone_number => params["From"])
		user_id = reminder.user_id if reminder.present?

		# create vars for pushup record
		@number_of_pushups = params["Body"].to_i
		today = Date.today

		if reminder.present?
			user = User.find(user_id)

			# add new pushup for user with given params
			pushup = user.pushups.new(amount: @number_of_pushups, date: today)
			pushup.teams << current_user_teams(user)
			user.save

			# text user a confirmation message
			render 'process_sms.xml.erb', :content_type => 'text/xml'
		else
			render 'process_sms_error.xml.erb', :content_type => 'text/xml'
		end
  end

	private

		# this is a dupe method from dashboard_helper
		def current_user_teams(user, arr=[])
			teams = user.teams
			teams.each do |team|
				arr << team
			end
			arr
		end
end
