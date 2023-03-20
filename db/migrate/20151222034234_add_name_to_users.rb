class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
		add_column :users, :name, :string
		add_column :users, :company, :string
		add_column :users, :company_website, :string
  end
end
