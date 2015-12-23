class RegistrationsController < Devise::RegistrationsController
	after_action :set_team_slug, only: [:create]

	private
		def set_team_slug
			subdomain = request.subdomain.downcase
			# checks for existing team or creates new
			@team = Team.find_by(subdomain: subdomain)
			if @team.present?
				@user.teams << @team
			else
				team = Team.new(subdomain: subdomain, user_id: @user.id)
				team.save
				@user.teams << team
			end
		end

  	def sign_up_params
  		params.require(:user).permit(:email, :name, :company, :company_website, :password)
  	end

  	def account_update_params
  		params.require(:user).permit(:email, :name, :company, :company_website, :password)
  	end

		def update_resource(resource, params)
			resource.update_without_password(params)
		end

end
