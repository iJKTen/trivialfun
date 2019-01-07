class Round < ApplicationRecord
  belongs_to :game
  has_many :questions, dependent: :destroy, inverse_of: :round
  accepts_nested_attributes_for :questions

  attr_accessor :category_id
  validates :category_id, presence: true, on: :create

  def self.create_tiebreaker_round(game)
    category = Category.where(:title => :Tiebreaker).limit(1).first
    round = Round.new(:game => game, :title => :Tiebreaker, :category_id => category.id, :order => game.rounds.count + 1)
    round.save!
    round
  end

  def questions_titles
    questions.each.map{ |question|
      question.title unless question.title.empty?
    }
  end

  def assign_questions(new_questions)
    new_question = new_questions.pop if new_questions.count > 0
    questions.build(:title => new_question[0], :answer => new_question[1], :order => questions.count + 1).save!
  end
end
