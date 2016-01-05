class PushupsController < ApplicationController
	include PushupsHelper
	include DashboardHelper
	before_action :set_pushup, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # GET /pushups/new
  def new
    @pushup = current_user.pushups.new
  end

  # GET /pushups/1/edit
  def edit
  end

  def history
    pushups = Pushup.where(user_id: current_user.id)
    @pushups = pushups.paginate(:page => params[:page], :per_page => 10).order('date DESC')
  end

	# POST /pushups
  def create
    month, day, year = params["pushup"]["date"].split("/")
    params["pushup"]["date"] = DateTime.new(year.to_i, month.to_i, day.to_i)
    @pushup = current_user.pushups.new(pushup_params)
    user = User.find(@pushup.user_id)
    if @pushup.save
      @pushup.teams << current_user_teams # associate pushup record to all of user's teams
      redirect_to dashboard_path
      Peanus.ping "new pushup logged: #{@pushup.amount} by #{user.name} // #{user.email}"
    else
      render :new
    end
  end

  # PATCH/PUT /pushups/1
  def update
    if @pushup.update(pushup_params)
    	redirect_to dashboard_path
    else
    	render :edit
    end
  end

  # DELETE /pushups/1
  def destroy
    @pushup.destroy
      redirect_to history_path
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_pushup
      @pushup = Pushup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pushup_params
      params.require(:pushup).permit(:amount, :date, :user_id)
    end
end
