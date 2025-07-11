class AuthController < ApplicationController
    skip_before_action :authorize_request

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: user.id, user_adm: user.adm })
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
