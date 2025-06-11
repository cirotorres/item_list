class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]
  before_action :authorize_admin!, only: [ :update, :destroy, :create ]
  include Rails.application.routes.url_helpers


  # GET /items
  def index
    @items = Item.all

    render json: @items.map { |item| item_response(item) }
  end

  # GET /items/1
  def show
    render json: item_response(@item)
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if params[:images]
      params[:images].each { |img| @item.images.attach(img) }
    end

    if @item.save
      render json: item_response(@item), status: :created
    else
      Rails.logger.debug(@item.errors.full_messages)
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if params[:removed_image_ids].present?
      image_ids = JSON.parse(params[:removed_image_ids])
      image_ids.each do |img_id|
        image = @item.images.find_by(id: img_id)
        image.purge if image
      end
    end
    if params[:images]
      params[:images].each { |img| @item.images.attach(img) }
    end

    if @item.update(item_params)
      render json: item_response(@item)
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy!
    render json: { message: "Item deletado com sucesso", id: @item.name }, status: :ok
  end

  def item_response(item)
    response = {
      id: item.id,
      name: item.name,
      price: item.price,
      description: item.description
    }
    if item.images.attached?
      response[:images] = item.images.map do |img|
        {
          id: img.id,
          url: url_for(img),
          thumb_url: url_for(img.variant(resize_to_limit: [ 150, 150 ]))
        }
      end
    end
    response
  end

  def purge_image
    image = ActiveStorage::Attachment.find(params[:image_id])
    image.purge
    head :no_content
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [ :name, :price, :description ])
    end
end
