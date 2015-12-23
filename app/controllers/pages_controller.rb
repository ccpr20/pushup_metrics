class PagesController < ApplicationController
  def home
  end

	def choose
		@teams = current_user.teams
		@domain = request.domain
	end
end
