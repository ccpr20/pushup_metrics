class OwnerController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_user, only: [:destroy]
    before_action :set_pushups, only: [:delete_pushups]

    def index
        users = User.where.not(email: 'murray_ben@yahoo.com')
        @owners = users.paginate(:page => params[:page], :per_page => 10).order('name')

        respond_to do |format|
            format.html
            format.csv { send_data users.to_csv, filename: "users-#{Date.today}.csv" }
        end
    end

    def delete_pushups
        @pushups.destroy_all
        logger.debug 'deleted pushups'
        redirect_to owner_index_path 
    end

    def destroy
        @user.destroy
        logger.debug 'deleted user'
        redirect_to owner_index_path
    end

    private
        def check_admin
            if current_user[:email] != 'murray_ben@yahoo.com'
                redirect_to log_pushup_path
            end
        end

        def set_user
            @user = User.find(params[:id])
        end

        def set_pushups
            @pushups = Pushup.where(user_id: params[:owner_id])
        end
end
