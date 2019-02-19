class Pushup < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :teams
	accepts_nested_attributes_for :teams

	after_create do
		u = user
		cached_total = u.total_pushups_cached
		u.update(total_pushups_cached: cached_total += amount)
	end

	before_destroy do
		u = user
		cached_total = u.total_pushups_cached
		u.update(total_pushups_cached: cached_total -= amount)
	end
end
