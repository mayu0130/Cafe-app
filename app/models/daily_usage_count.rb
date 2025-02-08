class DailyUsageCount < ApplicationRecord
  belongs_to :user

  validates :used_date, presence: true
  validates :usage_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :used_date, uniqueness: { scope: :user_id }
end
