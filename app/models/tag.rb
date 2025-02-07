class Tag < ApplicationRecord
  has_and_belongs_to_many :posts

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
