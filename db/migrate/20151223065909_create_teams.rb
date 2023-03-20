class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
			t.string :subdomain
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
