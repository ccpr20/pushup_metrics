class PushupsController < ApplicationController
	include PushupsHelper
	before_action :set_pushup, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # GET /pushups
  def index
    user_pushups = Pushup.where(user_id: current_user.id)
		@pushups = hashify(user_pushups) # sort pushups by log date, create key:value pair
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}
		@user_amounts = @pushups.values.map {|p| p }
		@user_sum = get_sum(@user_amounts)
		@global_average = global_average
		@global_leader = global_leader
		@global_portion = global_portion
		@global_sum = get_sum(global_pushups)
  end

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
  # POST /pushups.json
  def create
		month, day, year = params["pushup"]["date"].split("/")
		params["pushup"]["date"] = DateTime.new(year.to_i, month.to_i, day.to_i)
    @pushup = current_user.pushups.new(pushup_params)
      if @pushup.save
        redirect_to dashboard_path
      else
        render :new
      end
  end

  # PATCH/PUT /pushups/1
  # PATCH/PUT /pushups/1.json
  def update
      if @pushup.update(pushup_params)
        redirect_to @pushup
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

		def hashify(pushups, hash={})
			pushups.each do |p|
				hash[p.date] = p.amount.to_i
			end
			hash.sort.to_h # sort returns array, revert back to hash
		end

    # Use callbacks to share common setup or constraints between actions.
    def set_pushup
      @pushup = Pushup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pushup_params
      params.require(:pushup).permit(:amount, :date, :user_id)
    end
end
