class AddShowAgeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :show_age, :boolean, :default => true
  end
end
