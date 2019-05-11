class Article < ApplicationRecord
    has_one_attached :thumbnail
    has_many_attached :images
end
