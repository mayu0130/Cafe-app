class Post < ApplicationRecord
  validates :cafe_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :address, presence: true, length: { minimum: 2, maximum: 50 }
  validates :cafe_link, format: { with: URI::regexp(%w[http https]), allow_blank: true }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_and_belongs_to_many :tags

  has_one_attached :image

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

end
