class Roster < ApplicationRecord
  has_many :subscriptions
  has_many :venues, :through => :subscriptions

  default_scope { order(name: :asc) }

  def self.find_or_create_new(roster_id, name, email)
    roster = nil
    if roster_id.empty?
      if !name.empty? && !email.empty?
        roster = Roster.find_or_create_by(:email => email) do |r|
          r.name = name
        end
      end
    else
      roster = Roster.find(roster_id)
    end

    roster
  end

  def times_played
    Player.where(:roster => self).count
  end

end
