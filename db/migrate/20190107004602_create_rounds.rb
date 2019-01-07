class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.string :title
      t.integer :order
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
