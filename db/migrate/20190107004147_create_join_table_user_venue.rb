class CreateJoinTableUserVenue < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :venues, :id => false do |t|
      t.references :user, foreign_key: true
      t.references :venue, foreign_key: true
    end
    add_index(:users_venues, [:user_id, :venue_id], :unique => true)
  end
end
