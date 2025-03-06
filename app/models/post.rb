class Post < ApplicationRecord
  validates :cafe_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :address, presence: true, length: { minimum: 2, maximum: 100 }
  validates :cafe_link, format: { with: URI::regexp(%w[http https]), allow_blank: true },length: { minimum: 5, maximum: 150 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :favorites, dependent: :destroy

  has_one_attached :image

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  PREFECTURES = [
    '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県',
    '茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県',
    '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県',
    '静岡県', '愛知県', '三重県', '滋賀県', '京都府', '大阪府', '兵庫県',
    '奈良県', '和歌山県', '鳥取県', '島根県', '岡山県', '広島県', '山口県',
    '徳島県', '香川県', '愛媛県', '高知県', '福岡県', '佐賀県', '長崎県',
    '熊本県', '大分県', '宮崎県', '鹿児島県', '沖縄県'
  ]

  def self.ransackable_attributes(auth_object = nil)
    %w[cafe_name body address]
  end

  def self.ransackable_associations(auth_object = nil)
    ['tags']
  end

  def favorited_by?(user)
    return false if user.nil?
    favorites.exists?(user_id: user.id)
  end

end
