class Item < ApplicationRecord
  validates :name, :price, presence: true
  # has_one_attached :image_main
end
