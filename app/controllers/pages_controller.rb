class PagesController < ApplicationController

	def home
		puts 'actionmailer config ', ActionMailer::Base.smtp_settings
		redirect_to dashboard_path if current_user
 	end

	def choose
		@teams = current_user.teams
		@domain = request.domain
	end

end
