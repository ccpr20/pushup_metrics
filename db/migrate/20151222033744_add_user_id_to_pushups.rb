class AddUserIdToPushups < ActiveRecord::Migration
  def change
    add_column :pushups, :user_id, :integer
		add_index :pushups, :user_id
  end
end
