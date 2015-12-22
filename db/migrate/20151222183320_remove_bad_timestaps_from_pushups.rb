class RemoveBadTimestapsFromPushups < ActiveRecord::Migration
  def change
		remove_column :pushups, :created_at
		remove_column :pushups, :updated_at
  end
end
