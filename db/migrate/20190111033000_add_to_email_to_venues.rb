class AddToEmailToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :to_email, :string
  end
end
