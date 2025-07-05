class Announcement < ApplicationRecord
  has_many_attached :images
  validate :limit_images_count
  self.inheritance_column = :_type_disabled

  private

  def limit_images_count
    if images.attached? && images.count > 5
      errors.add(:images, "máximo de 5 imagens permitidas")
    end
  end
end
