class CreatePushupsTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :pushups_teams, :id => false do |t|
			t.references :pushup
			t.references :team
    end
		add_index :pushups_teams, [:pushup_id, :team_id]
		add_index :pushups_teams, :team_id
  end
end
