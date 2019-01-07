class Venue < ApplicationRecord
  has_and_belongs_to_many :users, -> { distinct }
  has_many :games, inverse_of: :venue
  has_many :subscriptions
  has_many :rosters, :through => :subscriptions
  validates :name, presence: true, length: { minimum: 4 }
  validates :address, presence: true, length: { minimum: 8 }
  validates :phone, presence: true
  validates_uniqueness_of :name, message: "Team name is taken"

  after_initialize :set_default_settings, :if => :new_record?

  def set_default_settings
    total_rounds_per_game = total_rounds_per_game&.nonzero? ? total_rounds_per_game : 4
    total_questions_per_round = total_questions_per_round&.nonzero? ? total_questions_per_round : 5
    maximum_players_per_team = maximum_players_per_team&.nonzero? ? maximum_players_per_team : 2
  end

  def subscribe(roster, newsletter)
    subscription = subscriptions.build(:roster => roster, :newsletter => newsletter)
    subscription.save!
  end

  def questions_not_asked_for_category(id)
    existing_questions = questions_at_venue
    Questionnaire.top_unasked_question_for_category(id, existing_questions)
  end

  def ordered_games
    games.order(winner: :desc, date: :asc)
  end

  def most_wins_by_teams
    Game.joins(:venue, :teams).limit(5)
                      .where("venues.id = #{self.id}")
                      .where("winner != ''")
                      .where("games.winner = teams.name").select("winner")
                      .group("winner").order("count_winner desc").count
  end

  def most_wins_by_player
    Roster.joins(subscriptions: [{venue: [{games: [{teams: :players}]}]}]).limit(5)
          .where("venues.id=3")
          .where("games.winner != ''")
          .where("games.winner = teams.name")
          .where("players.roster_id = rosters.id")
          .group("rosters.id, rosters.name").order("count_all desc").count
  end

  def most_player_played
    Roster.joins(subscriptions: [{venue: [{games: [{teams: :players}]}]}]).limit(5)
          .where("venues.id=3")
          .where("players.roster_id = rosters.id")
          .group("rosters.id, rosters.name").order("count_all desc").count
  end

  def most_tiebreaker_playing_teams
    Team.joins([{game: :rounds}]).limit(5)
                                 .where("games.venue_id = #{self.id}")
                                 .where("rounds.title = 'Tiebreaker'")
                                 .select("teams.name")
                                 .group("teams.name").order("count_teams_name desc").count
  end

  def most_tiebreaker_winning_teams
    Team.joins([{game: :rounds}]).limit(5)
                                 .where("games.venue_id = #{self.id}")
                                 .where("games.winner != ''")
                                 .where("rounds.title = 'Tiebreaker'")
                                 .select("teams.name")
                                 .group("teams.name").order("count_teams_name desc").count
  end

  private
    def questions_at_venue
      questions = Question.joins([round: :game]).select("questions.title")
                                              .where("games.venue_id=#{id}")
                                              .pluck(:title)
      questions.uniq { |q| q }
    end
end
