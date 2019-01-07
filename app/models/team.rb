class Team < ApplicationRecord
  belongs_to :game
  has_many :players, dependent: :destroy, inverse_of: :team
  has_many :answers, dependent: :destroy, inverse_of: :team
  accepts_nested_attributes_for :players
  accepts_nested_attributes_for :answers

  validates :name, presence: { message: "must have a name" }
  validates_uniqueness_of :name, scope: :game, message: "Team name is taken"
  validates :players, presence: { message: "must have at least one player" }

  validate :unique_player_per_game_create, on: :create
  validate :unique_player_per_game_update, on: :update

  after_create :create_team_answer

  def update_answers(params)
    ActiveRecord::Base.transaction do
      params[:team][:answers_attributes].keys.each {|index|
        answer = Answer.find(params[:team][:answers_attributes][index][:id])
        answer.answer = params[:team][:answers_attributes][index][:answer]
        answer.correct = params[:team][:answers_attributes][index][:correct]
        answer.save!
      }
      true
    end
    rescue Exception => e
      errors.add(:base, e.message)
      false
  end

  def score
    answers.where(:correct => 1).count
  end

  def create_team_answer
    game.rounds.each {|round|
      round.questions.each {|question|
        answer_index = answers.count + 1
        Answer.new(:team => self, :question => question, :order => answer_index).save!
      }
    }
  end

  def unique_player_per_game_update
    players.each {|p|
      players_found = Player.joins(:roster, [{team: :game}])
                            .where("games.id = #{game.id} and teams.id != #{id} and rosters.email = '#{p.roster.email}'").count
      errors.add(:team, "player has to be unique per game") if players_found >= 1
    }
  end

  def unique_player_per_game_create
    players.entries.each {|p|
      players_found = Player.joins(:roster, [{team: :game}])
                            .where("games.id = #{game.id} and rosters.email = '#{p.roster.email}'").count
      errors.add(:team, "player has to be unique per game") if players_found >= 1
    }
    errors.add(:team, "Player has to be unique per team") if players.entries.uniq { |q| q.roster_id }.count != players.entries.count
  end

  def add_open_player_slot_if_available
    num_of_open_player_slots.times {
      players.build
    }
  end

  def make_winner
    self.update_attributes(:won => true)
    game.update_attributes(:winner => self.name)
  end

  private
    def num_of_open_player_slots
      game.venue.maximum_players_per_team - players.count
    end
end
