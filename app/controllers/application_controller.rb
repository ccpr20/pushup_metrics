class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_user
	before_action :set_team
	before_action :set_subdomain
	before_action :mixpanel

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new ENV['MIXPANEL_TOKEN']
  end

	def set_user
		@user = current_user if current_user
	end

	def after_sign_in_path_for(resource)
		log_pushup_path
	end

	def set_team
		@team = Team.find_by(subdomain: @subdomain)
	end

	def set_subdomain
		@subdomain = request.subdomain.downcase.gsub("www.", "")
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up) do |user|
			user.permit(:email, :name, :password, :password_confirmation, team_attributes: [:subdomain])
		end
	end

	def redirect_team_choice
		subdomain = current_user.teams.first.subdomain
	end

end
