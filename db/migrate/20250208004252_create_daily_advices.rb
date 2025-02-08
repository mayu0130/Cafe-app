class CreateDailyAdvices < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_advices do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :generated_at, null: false

      t.timestamps
    end

    add_index :daily_advices, [:user_id, :generated_at]
  end
end
