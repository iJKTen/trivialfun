class Answer < ApplicationRecord
  belongs_to :team
  belongs_to :question

  accepts_nested_attributes_for :question

  default_scope { order(order: :asc) }
end
