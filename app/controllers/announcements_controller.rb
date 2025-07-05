class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: %i[show update destroy]
  before_action :authorize_admin!, only: %i[update destroy create]

  def index
    @announcements = Announcement.all
    @announcements = @announcements.where(type: params[:type]) if params[:type].present?
    @announcements = @announcements.order(:position)

    render json: @announcements.map { |a| serialize(a) }
  end

  def show
    render json: serialize(@announcement)
  end

def create
  # Limite máximo de 5 banners no total
  if announcement_params[:type] == "banner" && Announcement.where(type: "banner").count >= 5
    return render json: { error: "Limite apenas de 5 banners" }, status: :unprocessable_entity
  end

  if announcement_params[:type] == "popups" && Announcement.where(type: "popups").count >= 1
    return render json: { error: "limite apenas de 1 popup" }, status: :unprocessable_entity
  end

  @announcement = Announcement.new(announcement_params)

  if params[:images]
    params[:images].each { |img| @announcement.images.attach(img) }
  end

  if @announcement.save
    render json: { success: true, announcement: serialize(@announcement) }, status: :created
  else
    render json: @announcement.errors.full_messages, status: :unprocessable_entity
  end
end


def update
  if params[:removed_image_ids].present?
    image_ids = JSON.parse(params[:removed_image_ids])
    image_ids.each do |img_id|
      image = @announcement.images.find_by(id: img_id)
      image.purge if image
    end
  end

  if params[:images]
    params[:images].each { |img| @announcement.images.attach(img) }
  end

  if @announcement.update(announcement_params)
    render json: { success: true, announcement: serialize(@announcement) }
  else
    render json: @announcement.errors.full_messages, status: :unprocessable_entity
  end
end


  def destroy
    @announcement.destroy!
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def announcement_params
    params.require(:announcement).permit(:title, :description, :position, :type)
  end

  def serialize(announcement)
    {
      id: announcement.id,
      title: announcement.title,
      description: announcement.description,
      position: announcement.position,
      type: announcement.type,
      images: announcement.images.map { |img| url_for(img) }
    }
  end
end
