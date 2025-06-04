class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_reader :current_user

  def authorize_admin!
    render json: { error: "Acesso restrito a administradores" }, status: :unauthorized unless current_user&.adm?
  end

  private

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = JsonWebToken.decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded
    raise ActiveRecord::RecordNotFound unless @current_user
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: "Unauthorized" }, status: :unauthorized
  end
end
