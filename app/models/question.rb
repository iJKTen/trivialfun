class Question < ApplicationRecord
  belongs_to :round
  has_many :answers, dependent: :destroy

  before_create :add_question_from_questionnaire_if_empty
  before_update :add_question_from_questionnaire_if_empty
  before_create :add_question_to_questionnaire

  default_scope { order(order: :asc) }

  def add_question_to_questionnaire
    num_of_existing_questions = Questionnaire.where(:title => title).count
    if num_of_existing_questions == 0 && !self.title.empty? && !self.answer.empty?
      Questionnaire.new(:title => self.title, :answer => self.answer, :category_id => round.category_id).save!
    end
  end

  def add_question_from_questionnaire_if_empty
    if self.title.empty?
      new_question = round.game.venue.questions_not_asked_for_category(round.category_id)
      q = new_question.pop if new_question.count > 0
      self.title = q[0] unless q.nil?
      self.answer = q[1] unless q.nil?
    end
  end
end
