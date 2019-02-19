class LeaderboardController < ApplicationController
  def index
    user_ids = Pushup.where(created_at: 90.days.ago..Time.now).map(&:user_id).uniq
    @leaders = User.where(id: user_ids).order('total_pushups_cache desc')
  end
end
