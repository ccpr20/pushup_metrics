class DashboardController < ApplicationController
	include PushupsHelper
	include DashboardHelper
	before_action :authenticate_user!, only: [:private, :all_teams]
	before_action :check_if_team_exists, only: [:team]
	before_action :check_if_pushups_exist, only: [:private]
	before_action :set_pushup, only: [:show, :edit, :update, :destroy]

	def private
		user_pushups = Pushup.where(user_id: current_user.id)
		@pushups = hashify_team(user_pushups)
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")} #.sort
		@user_amounts = combine_daily_logs(@pushups)
		@user_sum = combine_team_pushups(@pushups.keys, @user_amounts)

		mixpanel.track current_user.id, "View Personal Dashboard"
	end

	def team
		# retrieve team that matches subdomain
		team_pushups = current_team_pushups(@subdomain)

		@pushups = hashify_team(team_pushups) # creates hash of pushup log date:amount
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}.sort
		@team_amounts = combine_daily_logs(@pushups) # when multiple entries exist on a single date
		@combined_team_pushups = combine_team_pushups(@pushups.keys, @team_amounts)

		mixpanel.track current_user.id, "View Team Dashboard" if current_user
	end

	# landing page to select a team for when user belongs to more than 1
	def all_teams
		redirect_to team_dashboard_path unless current_user.teams.count > 1
		@teams = current_user.teams
		@domain = request.domain

		mixpanel.track current_user.id, "View All Teams"
	end

	def sorry
	end

	private

		def check_if_pushups_exist
			redirect_to new_pushup_path unless @user.pushups.count > 0
		end

		def check_if_team_exists
			existing_teams = Team.where(subdomain: @subdomain)
			redirect_to undefined_team_path if !existing_teams.present?
		end

		def set_pushup
			@pushup = Pushup.find(params[:id])
		end
end
