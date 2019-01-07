class AddIndexToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_index(:players, [:roster_id, :team_id], :unique => true)
  end
end
