class AddShowGenderToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :show_gender, :boolean, :default => true
  end
end
