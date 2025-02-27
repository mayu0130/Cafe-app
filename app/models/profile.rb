class Profile < ApplicationRecord
   validates :nickname, presence: true, length: { maximum: 50 }
   validates :mbti, format: { with: /\A[A-Z]{4}\z/, message: '英語の大文字4文字（例: INFP, ESTJ）」で入力してください' }, allow_blank: true
   validates :address, length: { maximum: 100 }, allow_blank: true
   validates :introduction, presence: true, length: { maximum: 500 }
   validates :x_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'は有効なURLである必要があります' }, allow_blank: true
   validates :instagram_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'は有効なURLである必要があります' }, allow_blank: true

  belongs_to :user
  has_one_attached :avatar
end
