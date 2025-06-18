class CartsController < ApplicationController
  before_action :set_cart

  def show
    render json: {
      cart: @cart,
      items: @cart.cart_items.includes(:item).map do |ci|
        {
          item_id: ci.item.id,
          name: ci.item.name,
          quantity: ci.quantity,
          price: ci.item.price,
          images: ci.item.images.map { |img| { thumb_url: url_for(img.variant(resize_to_limit: [ 150, 150 ])) } }

        }
      end
    }
  end

  def add_item
    item = Item.find(params[:item_id])
    cart_item = @cart.cart_items.find_or_initialize_by(item: item)

    if cart_item.new_record?
      cart_item.quantity = params[:quantity].to_i
    else
      cart_item.quantity += params[:quantity].to_i

    end
    cart_item.save!
    render json: { success: true, cart_item: cart_item }, status: :ok
  end

  def remove_item
    cart_item = @cart.cart_items.find_by(item_id: params[:item_id])
    if cart_item
      cart_item.destroy
      render json: { success: true }, status: :ok
    else
      render json: { error: "Item not found in cart" }, status: :not_found
    end
  end

  def finalize
    @cart.update(status: :completed)
    render json: { success: true, message: "Pedido finalizado com sucesso." }
  end

  private

  def set_cart
    @cart = @current_user.carts.find_or_create_by(status: :active)
  end
end
