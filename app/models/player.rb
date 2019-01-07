class Player < ApplicationRecord
  belongs_to :roster
  belongs_to :team

  attr_accessor :delete

  def roster_name
    roster.name unless roster.nil?
  end

  def roster_email
    roster.email unless roster.nil?
  end

  def roster_newsletter
    roster.subscriptions.where(:venue => team.game.venue) unless roster.nil?
  end

  def subscription_status
    roster.subscriptions.where(:venue => team.game.venue).first.newsletter
  end
end
