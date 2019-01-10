class Questionnaire < ApplicationRecord
  belongs_to :category

  def self.top_unasked_question_for_category(category_id, existing_questions)
    Questionnaire.limit(1)
                 .order("RANDOM()")
                 .select("title", "answer")
                 .where(category_id: category_id)
                 .where.not(title: existing_questions).pluck(:title, :answer)
  end
end
