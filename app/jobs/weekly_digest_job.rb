class WeeklyDigestJob
  include SuckerPunch::Job

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      recipients = get_recipients
      contenders = get_contenders
      record_holders = get_record_holders(contenders)
      users = User.find(recipients)

      users.each do |user|
        WeeklyDigest.send_records(user, record_holders).deliver_now
        puts "Sent digest to #{user.name}"
      end
    end
  end

  # only notify users who have logged within the last 30 days
  def get_recipients
    pushups_this_month = Pushup.where(created_at: 30.days.ago..Time.now)
    pushups_this_month.map(&:user_id).uniq
  end

  # only analyze users who logged pushups this week
  def get_contenders
    pushups_this_week = Pushup.where(created_at: 7.days.ago..Time.now)
    contenders = pushups_this_week.map(&:user_id).uniq
  end

  # loop through array of contenders, grabbing personal bests and checking if broken recently
  def get_record_holders(contenders, record_holders=[])
    contenders.each do |contender|
      # step 1 - get all pushups
      pushups = Pushup.where(user_id: contender).map(&:amount)

      # step 2 - get personal best
      personal_best = pushups.max
      personal_best_date = Pushup.where(amount: personal_best, user_id: contender).last.created_at

      # step 3 - get former personal best
      pushups.delete(personal_best)
      former_best = pushups.max

      # check whether personal best was created since last weekly digest
      if personal_best_date > 7.days.ago  && !former_best.nil?
        improvement = (((personal_best.to_f / former_best) - 1) * 100).round(2) # coerce to % change
        name = User.find(contender).name.split[0]
        record_holders << [name, improvement]
      end
    end
    record_holders
  end

end
