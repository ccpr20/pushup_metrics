module DashboardHelper

	def hashify_team(pushups, output={})
		pushups.map { |p| output.key?(p.date) ? output[p.date] << p.amount : output[p.date] = [p.amount] }
		output
	end

	def combine_daily_logs(pushups, arr=[])
		pushups.values.each { |values| arr << values.reduce(0,:+) }
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

	def combine_weekly_logs(pushups, today)
		total = 0
		seventh_day = today -7
		date = today
			while date > seventh_day
				current_records =  pushups.find_by(date:  date)
				current_records.tap do    |r|total += r.amount end if current_records.present?
				date-=1
			end
			return total
	end

	def current_team_pushups(subdomain, arr=[])
		current_team_id = Team.find_by(subdomain: subdomain).id
		all_pushups = Pushup.all

		# get all team IDs for given indvidual pushup
		team_array = []
		all_pushups.each do |p|
			pushup_id = p.id
			p.teams.each do |team|
				team_array << pushup_id if (team.subdomain == subdomain)
			end
		end

		# add given pushup if it belongs to the team being viewed
		all_pushups.each do |p|
			arr << p if team_array.include?(p.id)
		end
		arr # returns array of pushups associated with team being viewed
	end

	def current_user_teams(arr=[])
		teams = current_user.teams
		teams.each do |team|
			arr << team unless arr.include?(team)
		end
		arr
	end

	def team_members_count
		team = Team.find_by(subdomain: @subdomain)
		team.users.count
	end

	def best_individual_set(pushups)
		pushups.values.flatten.max
	end
end
