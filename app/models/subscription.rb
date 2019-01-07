class Subscription < ApplicationRecord
  belongs_to :venue
  belongs_to :roster
end
