class SessionsController < Devise::SessionsController
	after_action :set_team_slug, only: [:create]
	after_action :set_person, only: [:create]

	private

	def set_person
		# reminder deleted via remove_nil_reminder if not provided
		if @user.reminders.count > 0
			mixpanel.people.set(@user.id, {
				'$email' => @user.email,
				'$id' => @user.id,
				'$first_name' => @user.name.split[0],
				'$last_name' => @user.name.split[1],
				'$phone_number' => @user.reminders.first.phone_number
				})
		else
			mixpanel.people.set(@user.id, {
				'$email' => @user.email,
				'$id' => @user.id,
				'$first_name' => @user.name.split[0],
				'$last_name' => @user.name.split[1],
				'$phone_number' => nil
				})
		end
		mixpanel.track @user.id, "Login"
	end

		def set_team_slug
			# checks for existing team or creates new
			@team = Team.find_by(subdomain: @subdomain)
			if @team.present?
				@user.teams << @team unless user_already_on_team?
			else
				team = Team.new(subdomain: @subdomain, name: @subdomain, user_id: @user.id)
				team.save
				@user.teams << team
			end
		end

		def user_already_on_team? # avoids create new Team object with existing Team ID
			@user.teams.each do |t|
				return true if t == @team
			end
			false
		end

end
