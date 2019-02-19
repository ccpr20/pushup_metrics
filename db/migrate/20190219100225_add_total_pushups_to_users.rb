class AddTotalPushupsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_pushups_cached, :integer
  end
end
