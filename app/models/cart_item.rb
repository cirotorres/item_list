class CartItem < ApplicationRecord
  after_save :update_cart_item_count
  after_destroy :update_cart_item_count
  belongs_to :cart
  belongs_to :item

  validates :quantity, numericality: { greater_than: 0 }

  private

  def update_cart_item_count
    cart.update(item_count: cart.cart_items.sum(:quantity))
  end
end
