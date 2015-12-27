class PagesController < ApplicationController
	before_action :send_to_dashboard?, only: [:home]

	def home
  end

	def choose
		@teams = current_user.teams
		@domain = request.domain
	end

	private
		def send_to_dashboard?
			redirect_to dashboard_path if current_user
		end
end
