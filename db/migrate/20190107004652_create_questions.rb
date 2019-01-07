class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :answer
      t.integer :order
      t.references :round, foreign_key: true

      t.timestamps
    end
  end
end
