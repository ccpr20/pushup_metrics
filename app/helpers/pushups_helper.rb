module PushupsHelper

	def get_sum(pushups, total=0)
		pushups.each {|p| total += p}
		total
	end

	def global_pushups
		pushups = Pushup.all
		pushups.map {|p| p.amount.to_i}
	end

	def pushups_last_month(pushups, total=0)
		last_month = (Time.now.beginning_of_month - 1.day).beginning_of_month.to_i
		this_month = Time.now.beginning_of_month.to_i
		pushups.each do |k,v|
			total += v if k.to_i > last_month &&
										k.to_i < this_month
		end
		total
	end

	def pushups_this_month(pushups, total=0)
		this_month = Time.now.beginning_of_month.to_i
		pushups.each do |k,v|
			total += v if k.to_i > this_month
		end
		total
	end

	def global_average(total=0)
		global_pushups.each {|p| total+= p}
		count = global_pushups.count
		avg = total.to_f / count
		avg.round(0)
	end

	def global_leader
		global_pushups.max
	end

	def global_portion
		global_count = global_pushups.count
		user_count = Pushup.where(user_id: current_user.id).count
		return (user_count.to_f / global_count) if user_count > 0
		return 0 if user_count < 1
	end

end
