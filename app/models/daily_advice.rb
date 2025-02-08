class DailyAdvice < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :generated_at, presence: true
  validates :question, presence: true

  DAILY_LIMIT = 1

  after_create :increment_daily_usage

  private

  def increment_daily_usage
    usage_count = user.daily_usage_counts.find_or_create_by(used_date: Date.current)
    usage_count.increment!(:usage_count)
  end
end
