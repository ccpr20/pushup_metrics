class LeaderboardController < ApplicationController
  def index
    # @user_ids = Pushup.where(created_at: 90.days.ago..Time.now).group('user_id').order('sum_amount').sum('amount')
    # @leaders = User.where(id: @user_ids.keys)#.order('id')
    sql = "
      SELECT
          a.*,
          b.total_pushup
      FROM
          users a
      INNER JOIN (
          SELECT
              user_id,
              SUM(amount) total_pushup
          FROM
              pushups
          WHERE
              EXTRACT(DAY FROM now()-created_at) <= 90
          GROUP BY user_id
      ) b ON a.id = b.user_id
      AND a.hide_profile = false
      ORDER BY total_pushup DESC
    "
    @leaders = ActiveRecord::Base.connection.execute(sql)
  end
end
