class RemindersController < ApplicationController
	before_action :authenticate_user!
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  # GET /reminders
  def index
    @reminders = Reminder.all
  end

  # GET /reminders/1
  def show
  end

  # GET /reminders/new
  def new
    @reminder = current_user.reminders.new
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

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to dashboard_path, notice: 'Reminder was successfully created.' }
        format.json { render :show, status: :created, location: @reminder }
      else
        format.html { render :new }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reminders/1
  def update
    respond_to do |format|
      if @reminder.update(reminder_params)
        format.html { redirect_to dashboard_path, notice: 'Reminder was successfully updated.' }
        format.json { render :show, status: :ok, location: @reminder }
      else
        format.html { render :edit }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder.destroy
    respond_to do |format|
      format.html { redirect_to reminders_url, notice: 'Reminder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

		# Use callbacks to share common setup or constraints between actions.
    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reminder_params
      params.require(:reminder).permit(:phone_number, :time)
    end
end
