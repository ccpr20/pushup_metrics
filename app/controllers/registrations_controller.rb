class RegistrationsController < Devise::RegistrationsController
  after_action :set_team_slug, only: [:create]

  def create
    super
    # custom notification not included in open-source version
    Peanus.ping "new user! (#{@user.name} // #{@user.email})"
  end

    private
      def set_team_slug
        # checks for existing team or creates new
        @team = Team.find_by(subdomain: @subdomain)
        if @team.present?
          @user.teams << @team
        else
          team = Team.new(subdomain: @subdomain, name: @subdomain, user_id: @user.id)
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
