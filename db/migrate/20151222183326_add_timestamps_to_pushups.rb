class AddTimestampsToPushups < ActiveRecord::Migration[5.1]
	def change
			change_table(:pushups) { |t| t.timestamps }
	end
end
