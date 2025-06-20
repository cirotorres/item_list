# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authorize_request

  def index
    orders = @current_user.carts.completed.includes(cart_items: [ item: [ images_attachments: :blob ] ])

    render json: orders.map { |order|
      {
        id: order.id,
        created_at: order.created_at.strftime("%d/%m/%Y %H:%M"),
        total_price: order.cart_items.sum { |ci| ci.item.price * ci.quantity }.to_f.round(2),
        item_count: order.item_count,
        items: order.cart_items.map do |ci|
          {
            name: ci.item.name,
            quantity: ci.quantity,
            price: ci.item.price,
            subtotal: (ci.item.price * ci.quantity).to_f.round(2),
            images: ci.item.images.map do |img|
              { thumb_url: url_for(img.variant(resize_to_limit: [ 150, 150 ])) }
            end
          }
        end
      }
    }
  end
end
