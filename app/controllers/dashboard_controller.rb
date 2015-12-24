class DashboardController < ApplicationController
	include PushupsHelper
	include DashboardHelper
	before_action :set_pushup, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:private, :all_teams]

	# todo: before_action that redirects user if subdomain is not part of a team they belong to!

	def private
		user_pushups = Pushup.where(user_id: current_user.id)
		@pushups = hashify(user_pushups) # sort pushups by log date, create key:value pair
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}
		@user_amounts = @pushups.values.map {|p| p }
		@user_sum = get_sum(@user_amounts)
		@global_average = global_average
		@global_leader = global_leader
		@global_portion = global_portion_user
		@global_sum = get_sum(global_pushups)
	end

	def team
		# retrieve team that matches subdomain
		team_pushups = current_team_pushups(@subdomain)

		@pushups = hashify_team(team_pushups) # creates hash of pushup log date:amount
		@dates = @pushups.keys.map {|p| p.strftime("%b %d")}
		@team_amounts = combine_daily_logs(@pushups) # when multiple entries exist on a single date
		@combined_team_pushups = combine_team_pushups(@pushups.keys, @team_amounts)
	end

	def all_teams
		# landing page to select a team for when user belongs to more than 1
		redirect_to team_dashboard_path unless current_user.teams.count > 1
		@teams = current_user.teams
		@domain = request.domain
	end

	private

		def hashify(pushups, hash={})
			pushups.each do |p|
				hash[p.date] = p.amount.to_i
			end
			hash.sort.to_h # sort returns array, revert back to hash
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

		def set_pushup
			@pushup = Pushup.find(params[:id])
		end
end
