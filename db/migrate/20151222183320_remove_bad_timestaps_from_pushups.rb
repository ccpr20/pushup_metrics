class RemoveBadTimestapsFromPushups < ActiveRecord::Migration[5.1]
  def change
		remove_column :pushups, :created_at
		remove_column :pushups, :updated_at
  end
end
