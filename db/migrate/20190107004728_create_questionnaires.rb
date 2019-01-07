class CreateQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnaires do |t|
      t.string :title
      t.text :answer
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
