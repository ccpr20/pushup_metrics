class RemindersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  # GET /reminders/new
  def new
  	@reminder = current_user.reminders.new
    mixpanel.track current_user.id, "Start Adding Reminder"
  end

	def show
    mixpanel.track current_user.id, "View Reminders"
	end

  # POST /reminders
  def create
    @reminder = current_user.reminders.new(reminder_params)
    if @reminder.save
      flash.now[:notice] = "Reminder created!"
      redirect_to dashboard_path
      mixpanel.track current_user.id, "Finish Adding Reminder"
    else
      flash.now[:alert] = 'Error Creating Reminder!'
      render :new
    end
  end

  # PATCH/PUT /reminders/1
  def update
    if @reminder.update(reminder_params)
    	redirect_to dashboard_path
    else
      render :edit
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder.destroy
    mixpanel.track current_user.id, "Delete Reminder"
    redirect_to dashboard_path
  end

  private

    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    def reminder_params
      params.require(:reminder).permit(:phone_number, :time, :time_zone)
    end
end
