class AddDefaultToCachedPushups < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :total_pushups_cached, :integer, default: 0
    rename_column :users, :total_pushups_cached, :total_pushups_cache
  end
end
