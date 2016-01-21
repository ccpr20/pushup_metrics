class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  after_action :set_team_slug, only: [:create]

  # GET /signup
  def new
    # Override Devise default behaviour and create a reminder as well
    build_resource({})
    @reminder = resource.reminders.build
    # resource.build_reminder
    respond_with self.resource
  end

  def create
    super
    Peanus.ping "new user! (#{@user.name} // #{@user.email})"
  end

  protected

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
    params.require(:user).permit(:email, :name, :company, :company_website, :password, reminders_attributes: [:phone_number])
	end

	def account_update_params
    params.require(:user).permit(:email, :name, :company, :company_website, :password)
	end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
