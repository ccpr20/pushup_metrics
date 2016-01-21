class RemindersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  # GET /reminders/new
  def new
		if current_user.reminders.present?
			redirect_to existing_reminder_path
		else
    	@reminder = current_user.reminders.new
		end
  end

	def existing
		@reminders = current_user.reminders
	end

  # GET /reminders/1/edit
  def edit
  end

  # POST /reminders
  def create
		@reminder = current_user.reminders.new(reminder_params)
		# todo: let users specify their own daily reminder text
		# clock = params["time"].split(":")
		# hour = clock[0].to_i
		# minutes = clock[1][0..1]
		# time_of_day = clock[1][2..3].downcase
		# hour += 12 if time_of_day == "pm"
		# params["time"] = Time.new("#{hour.to_s}:#{minutes.to_s}")

    if @reminder.save
      redirect_to dashboard_path
    else
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
    redirect_to dashboard_path
  end

  private

    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    def reminder_params
      params.require(:reminder).permit(:phone_number, :time)
    end
end
