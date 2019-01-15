class AddEmailToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :email, :string
  end
end
