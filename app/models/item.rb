class Item < ApplicationRecord
  has_many_attached :images
  validates :name, :price, presence: true
  validate :limit_images_count

  has_many :cart_items
  private
  def limit_images_count
    if images.size > 5
      errors.add(:images, "máximo de 5 imagens")
    end
  end
end
