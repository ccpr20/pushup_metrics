class AddTimestampsToPushups < ActiveRecord::Migration
	def change
			change_table(:pushups) { |t| t.timestamps }
	end
end
