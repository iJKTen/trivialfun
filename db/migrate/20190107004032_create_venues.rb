class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.integer :total_rounds_per_game
      t.integer :total_questions_per_round
      t.integer :maximum_players_per_team

      t.timestamps
    end
  end
end
