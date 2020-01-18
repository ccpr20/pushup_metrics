class LeaderboardController < ApplicationController
  def index
    @user_ids = Pushup.where(created_at: 90.days.ago..Time.now).group('user_id').order('sum_amount').sum('amount')
    @leaders = User.where(id: @user_ids.keys)#.order('id')
    # sql = "
    #   SELECT
    #       a.*,
    #       b.total_pushup 
    #   FROM
    #       users a
    #   LEFT JOIN (
    #       SELECT
    #           user_id,
    #           SUM(amount) total_pushup
    #       FROM
    #           pushups
    #       WHERE
    #           EXTRACT(DAY FROM now()-created_at) <= 90
    #       GROUP BY user_id
    #   ) b ON a.id = b.user_id
    # "
    # @leaders = ActiveRecord::Base.connection.execute(sql)
    # logger.debug '***************************************************'
    # logger.debug @leaders.inspect
  end
end
