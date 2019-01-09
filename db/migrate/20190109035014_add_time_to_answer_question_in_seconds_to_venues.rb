class AddTimeToAnswerQuestionInSecondsToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :time_to_answer_question_in_seconds, :integer
  end
end
