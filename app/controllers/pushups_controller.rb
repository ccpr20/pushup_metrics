class PushupsController < ApplicationController
  include PushupsHelper
  include DashboardHelper
  before_action :set_pushup, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :reformat_date, only: [:create]

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
    @pushup = current_user.pushups.new(pushup_params)

    if @pushup.save
      @pushup.teams << current_user_teams # associate pushup record to all of user's teams
      redirect_to dashboard_path
      Peanus.ping "new pushup logged: #{@pushup.amount} by #{@user.name} // #{@user.email}"
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

    def reformat_date
      month, day, year = params['pushup']['date'].split("/")
      params['pushup']['date'] = DateTime.new(year.to_i, month.to_i, day.to_i)
    end

    def set_pushup
      @pushup = Pushup.find(params[:id])
    end

    def pushup_params
      params.require(:pushup).permit(:amount, :date, :user_id)
    end
end
