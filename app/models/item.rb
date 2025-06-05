class Item < ApplicationRecord
  has_one_attached :image
  validates :name, :price, presence: true
end
