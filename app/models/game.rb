class Game < ApplicationRecord
  belongs_to :venue
  has_many :rounds, -> { order 'rounds.order' }, dependent: :destroy, inverse_of: :game
  has_many :teams, dependent: :destroy, inverse_of: :game
  accepts_nested_attributes_for :rounds
  accepts_nested_attributes_for :teams
  validates :title, presence: true, length: { minimum: 4 }
  validates_uniqueness_of :title, message: "Game title is taken"
  validates :date, presence: true

  attr_reader :teams_tied

  def self.new_game_for_venue(venue)
    game = venue.games.build
    venue.total_rounds_per_game.times {|i|
      round = game.rounds.build(:order => i+1)
      venue.total_questions_per_round.times {|j|
        round.questions.build(:order => j+1)
      }
    }
    game
  end

  def sort_teams_by_score
    teams.sort_by { |t| -t.score }
  end

  def tiebreaker_question
    question = get_unanswered_tiebreaker_question
    create_tiebreaker_teams
    question.nil? ? create_tiebreaker_question : question
  end

  def create_tiebreaker_teams
    @teams_tied = []
    all_teams = sort_teams_by_score
    all_teams.each_index { |i|
        @teams_tied.append(all_teams[i]) if all_teams[i].score == all_teams[i-1].score
    }
  end

  def won
    !self.winner.empty? unless self.winner.nil?
  end

  private
    def create_tiebreaker_question
      tiebreaker_round = add_tiebreaker_round_if_not_present
      new_question = venue.questions_not_asked_for_category(tiebreaker_round.category_id)
      tiebreaker_round.assign_questions(new_question)
      setup_tiebreak_teams_answers(tiebreaker_round.questions.last)
      tiebreaker_round.questions.last
    end

    def setup_tiebreak_teams_answers(question)
      @teams_tied.each { |team|
        count = Answer.joins(:question, team: [{game: :venue}])
                      .where("venues.id = #{venue.id}")
                      .where("questions.title = '#{question.title}'")
                      .where("teams.id = #{team.id}").count
        Answer.new(:team => team, :question => question, :order => (question.order * -1)).save! if count == 0
      }
    end

    def add_tiebreaker_round_if_not_present
      round = rounds.where(:title => :Tiebreaker).count == 0 ? Round.create_tiebreaker_round(self) : rounds.last
      round.category_id = 1
      round
    end

    def get_unanswered_tiebreaker_question
      answers = Answer.limit(1).joins(question: [{round: :game}])
                      .where(rounds: { title: :Tiebreaker })
                      .where(games: {id: self.id})
                      .where(:answer => nil)
      answers.first.question if answers.count > 0
    end
end
