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
    @item.image.attach(params[:image]) if params[:image].present?

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    @item.image.attach(params[:image]) if params[:image].present?
    if @item.update(item_params)
      render json: item_response(@item)
    else
      render json: @item.errors, status: :unprocessable_entity
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
    if item.image.attached?
      response[:image_url] = url_for(item.image)
      response[:thumb_url] = url_for(item.image.variant(resize_to_limit: [ 150, 150 ]))
    end
    response
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
