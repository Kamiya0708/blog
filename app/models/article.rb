class Article < ApplicationRecord
  validates :title, presence: true

  has_one_attached :thumbnail
  has_many_attached :images
end
