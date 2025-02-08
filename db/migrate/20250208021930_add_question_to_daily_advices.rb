class AddQuestionToDailyAdvices < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_advices, :question, :text
  end
end
