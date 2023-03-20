class AddUserIdToPushups < ActiveRecord::Migration[5.1]
  def change
    add_column :pushups, :user_id, :integer
		add_index :pushups, :user_id
  end
end
