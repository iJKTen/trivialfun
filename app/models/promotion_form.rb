class PromotionForm
  include ActiveModel::Model

  attr_accessor :subject, :recipient_team, :promotional_text, :venue_name, :player
  validates :subject, presence: true, length: { minimum: 4 }
  validates :promotional_text, presence: true, length: { minimum: 4 }
  validates :recipient_team, presence: true

  def winning_teams(venue_id)
    teams = Team.joins(game: :venue).where("games.winner != ''")
                            .where("venues.id = #{venue_id}")
                            .where("teams.won = true").order("games.date desc")
    teams.collect{ |t| [t.name, t.id] }
  end
end
