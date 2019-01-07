class Category < ApplicationRecord
  has_many :questionnaires, inverse_of: :category
  default_scope { order(title: :asc) }
end
