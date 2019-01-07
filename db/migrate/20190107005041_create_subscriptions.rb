class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :venue, foreign_key: true
      t.references :roster, foreign_key: true
      t.boolean :newsletter

      t.timestamps
    end
  end
end
