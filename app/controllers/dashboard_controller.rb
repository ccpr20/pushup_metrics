class DashboardController < ApplicationController
	include PushupsHelper
	include DashboardHelper
	before_action :authenticate_user!, only: [:private, :all_teams]
	before_action :check_if_team_exists, only: [:team]
	before_action :check_if_pushups_exist, only: [:private]
	before_action :set_pushup, only: [:show, :edit, :update, :destroy]
	# todo: before_action that redirects user if subdomain is not part of a team they belong to!

	def private
		user_pushups = Pushup.where(user_id: current_user.id)
		@pushups = hashify_team(user_pushups)
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}
		@user_amounts = combine_daily_logs(@pushups)
		@user_sum = combine_team_pushups(@pushups.keys, @user_amounts)

		mixpanel.track current_user.id, "View Personal Dashboard"
	end

	def team
		# retrieve team that matches subdomain
		team_pushups = current_team_pushups(@subdomain)

		@pushups = hashify_team(team_pushups) # creates hash of pushup log date:amount
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}
		@team_amounts = combine_daily_logs(@pushups) # when multiple entries exist on a single date
		@combined_team_pushups = combine_team_pushups(@pushups.keys, @team_amounts)

		mixpanel.track current_user.id, "View Team Dashboard" if current_user 
	end

	def all_teams
		# landing page to select a team for when user belongs to more than 1
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

		def hashify_team(pushups, output={})
			pushups.each do |p|
				output[p.date] = []
			end
			output.each do |date, amounts|
				relevant_pushups = pushups.select {|p| p.date == date}
				relevant_pushups.each do |rel|
					amounts << rel.amount.to_i
				end
			end
			output.sort.to_h # sort method returns array, so revert back to hash
		end

		def combine_daily_logs(pushups, arr=[])
			pushups.values.each do |values|
				entries = values.count
				counter = 0
				total = 0
				while counter < entries
					total += values[counter]
					counter += 1
				end
				arr << total
			end
				arr
		end

		def combine_team_pushups(dates, amounts, output={})
			counter = 0
			dates.each do |d|
				output[d] = amounts[counter]
				counter += 1
			end
			output
		end

		def check_if_team_exists
			existing_teams = Team.where(subdomain: @subdomain)
			redirect_to undefined_team_path if !existing_teams.present?
		end

		def set_pushup
			@pushup = Pushup.find(params[:id])
		end
end
