class PushupsController < ApplicationController
  before_action :set_pushup, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

  # GET /pushups
  def index
    @pushups = Pushup.where(user_id: current_user.id)
		pushups = hashify(@pushups) # sort pushups by log date, create key:value pair
		@dates = pushups.keys.map {|p| p.strftime("%b %d")}
		@amounts = pushups.values.map {|p| p }
		@sum = get_sum(@amounts)
  end

  # GET /pushups/new
  def new
    @pushup = current_user.pushups.new
  end

  # GET /pushups/1/edit
  def edit
  end

  # POST /pushups
  # POST /pushups.json
  def create
		month, day, year = params["pushup"]["created_at"].split("/")
		params["pushup"]["created_at"] = DateTime.new(year.to_i, month.to_i, day.to_i)
    @pushup = current_user.pushups.new(pushup_params)
      if @pushup.save
        redirect_to dashboard_path, notice: 'Pushup was successfully recorded.'
      else
        render :new
      end
  end

  # PATCH/PUT /pushups/1
  # PATCH/PUT /pushups/1.json
  def update
    respond_to do |format|
      if @pushup.update(pushup_params)
        format.html { redirect_to @pushup, notice: 'Pushup was successfully updated.' }
        format.json { render :show, status: :ok, location: @pushup }
      else
        format.html { render :edit }
        format.json { render json: @pushup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pushups/1
  # DELETE /pushups/1.json
  def destroy
    @pushup.destroy
    respond_to do |format|
      format.html { redirect_to pushups_url, notice: 'Pushup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

		def hashify(pushups, hash={})
			pushups.each do |p|
				hash[p.created_at] = p.amount.to_i
			end
			hash.sort.to_h # sort returns array, revert back to hash
		end

		def get_sum(pushups, total=0)
			pushups.each {|p| total += p}
			total
		end

    # Use callbacks to share common setup or constraints between actions.
    def set_pushup
      @pushup = Pushup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pushup_params
      params.require(:pushup).permit(:amount, :created_at, :user_id)
    end
end