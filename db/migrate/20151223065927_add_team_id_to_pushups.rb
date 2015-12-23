class AddTeamIdToPushups < ActiveRecord::Migration
  def change
		add_column :pushups, :team_id, :integer
		add_index :pushups, :team_id
  end
end
