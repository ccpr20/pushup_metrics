class AddTotalPushupsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_pushups_cached, :integer
  end
end
