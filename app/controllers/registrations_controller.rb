class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  after_action :set_team_slug, only: [:create]
  after_action :remove_nil_reminder, only: [:create]
  after_action :set_person, only: [:create]
  after_action :update_slack, only: [:create]

  # GET /signup
  def new
    # Override Devise default behaviour and create reminder
    build_resource({})
    @reminder = resource.reminders.build # todo: replace build with reminders.new to avoid creating empty record
    respond_with self.resource
  end

  def edit
    mixpanel.track current_user.id, "View Settings"
  end

  private

  def update_slack
    Peanus.ping "new user! (#{@user.name} // #{@user.email})"
  end

  def set_person
    # reminder deleted via remove_nil_reminder if not provided
    if @user.reminders.count > 0
      mixpanel.people.set(@user.id, {
        '$email' => @user.email,
        '$first_name' => @user.name.split[0],
        '$last_name' => @user.name.split[1],
        '$phone_number' => @user.reminders.first.phone_number
        })
    else
      mixpanel.people.set(@user.id, {
        '$email' => @user.email,
        '$first_name' => @user.name.split[0],
        '$last_name' => @user.name.split[1],
        '$phone_number' => nil
        })
    end
    mixpanel.track @user.id, "Signup"
  end

  def remove_nil_reminder
    # remove empty reminder if no phone provided during registration
    reminder = @user.reminders.first
    reminder.destroy if reminder.phone_number.nil?
  end

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
