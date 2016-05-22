module PagesHelper

	# TODO: refactor - potentially ignore subdomain and check team Names only
	def user_has_team?
		# all users will have teams, even if empty, so check subdomain
		current_user.teams.each do |t|
			return true if t.subdomain != "" && t.subdomain != "www"
		end
		false
	end

end
