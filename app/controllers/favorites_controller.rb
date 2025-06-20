class FavoritesController < ApplicationController
  before_action :authorize_request
  before_action :set_favorite, only: [ :show ]

  def show
    render json: (
      @favorites.map do |f|
        {
          item_id: f.item.id,
          name: f.item.name,
          price: f.item.price,
          description: f.item.description,
          images: f.item.images.map { |img|
            { thumb_url: url_for(img.variant(resize_to_limit: [ 150, 150 ])) }
          }
        }
      end
    )
  end

  def add_fav
    item = Item.find(params[:item_id])
    fav_item = @current_user.favorites.find_or_create_by(item: item)
    render json: { success: true, favorite: fav_item }, status: :ok
  end

  def remove_fav
    fav = @current_user.favorites.find_by(item_id: params[:item_id])
    if fav
      fav.destroy
      render json: { success: true }
    else
      render json: { error: "Favorito não encontrado" }, status: :not_found
    end
  end

  private
  def set_favorite
    @favorites = @current_user.favorites.includes(item: [ images_attachments: :blob ])
  end
end
