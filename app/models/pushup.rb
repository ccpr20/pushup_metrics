class Pushup < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :teams
	accepts_nested_attributes_for :teams
	after_save :update_slack

	def update_slack
		user = User.find(self.user_id)
		Peanus.ping "new pushup logged: #{self.amount} by #{user.name} // #{user.email}"
	end
end
