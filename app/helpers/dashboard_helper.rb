module DashboardHelper

	def current_team_pushups(subdomain, arr=[])
		# binding.pry
		current_team_id = Team.find_by(subdomain: subdomain).id
		all_pushups = Pushup.all

		# get all team IDs for given indvidual pushup
		team_array = []
		all_pushups.each do |p|
			pushup_id = p.id
			p.teams.each do |team|
				team_array << pushup_id if team.subdomain == subdomain
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
			arr << team
		end
		arr
	end

	def team_members_count
		subdomain = request.subdomain.downcase
		team = Team.find_by(subdomain: subdomain)
		team.users.count
	end
end
