class SessionsController < Devise::SessionsController
	after_action :set_team_slug, only: [:create]

	private
		def set_team_slug
			subdomain = request.subdomain.downcase
			# checks for existing team or creates new
			@team = Team.find_by(subdomain: subdomain)
			if @team.present?
				@user.teams << @team unless user_already_on_team?
			else
				team = Team.new(subdomain: subdomain, user_id: @user.id)
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
