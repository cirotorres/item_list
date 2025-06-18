class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items

  enum :status, [ :active, :completed ]  # ✅ Rails 8 sintaxe nova
end
