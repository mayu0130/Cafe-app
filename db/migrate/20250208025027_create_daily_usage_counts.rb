class CreateDailyUsageCounts < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_usage_counts do |t|
      t.references :user, null: false, foreign_key: true
      t.date :used_date, null: false
      t.integer :usage_count, default: 0

      t.timestamps
    end
    add_index :daily_usage_counts, [:user_id, :used_date], unique: true
  end
end
