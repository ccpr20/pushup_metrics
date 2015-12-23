module PagesHelper

	def user_has_team?
		# all users will have teams, even if empty, so check for subdomain
		current_user.teams.each do |t|
			return true if t.subdomain != ""
		end
		false
	end

end
