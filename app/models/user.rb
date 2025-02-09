class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post

  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :daily_advices, dependent: :destroy
  has_many :daily_usage_counts, dependent: :destroy

  def display_name
    self.email.split('@').first
  end

  def mine?(post)
    self.id == post.user_id
  end

  def prepare_profile
    profile || build_profile
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      '<i class="fa-regular fa-user"></i>'.html_safe
    end
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  def follow!(user)
    user_id = get_user_id(user)
    following_relationships.create!(following_id: user_id)
  end

  def unfollow!(user)
    user_id = get_user_id(user)
    relation = following_relationships.find_by!(following_id: user_id)
    relation.destroy!
  end

  def has_followed?(user)
    following_relationships.exists?(following_id: user.id)
  end

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email) ||
           where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
             user.email = auth.info.email
             user.password = Devise.friendly_token[0, 20]
           end
    user
  end

  def can_generate_advice?
    usage_count = daily_usage_counts.find_or_create_by(used_date: Date.current)
    usage_count.usage_count < DailyAdvice::DAILY_LIMIT
  end

  def remaining_daily_attempts
    usage_count = daily_usage_counts.find_or_create_by(used_date: Date.current)
    [DailyAdvice::DAILY_LIMIT - usage_count.usage_count, 0].max
  end

  private

  def get_user_id(user)
    if user.is_a?(User)
      user.id
    else
      user
    end
  end

  MBTI_OPTIONS = [
    ['選択されていません', nil],
    ['INTJ', 'INTJ'],
    ['INTP', 'INTP'],
    ['ENTJ', 'ENTJ'],
    ['ENTP', 'ENTP'],
    ['INFJ', 'INFJ'],
    ['INFP', 'INFP'],
    ['ENFJ', 'ENFJ'],
    ['ENFP', 'ENFP'],
    ['ISTJ', 'ISTJ'],
    ['ISTP', 'ISTP'],
    ['ESTJ', 'ESTJ'],
    ['ESFJ', 'ESFJ'],
    ['ISFP', 'ISFP'],
    ['ESTP', 'ESTP'],
    ['ESFP', 'ESFP']
  ]
end
