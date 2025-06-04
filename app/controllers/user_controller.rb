class UserController < ApplicationController
  skip_before_action :authorize_request, only: [ :create ]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.expect(user: [ :email, :password, :adm ])
    end
end
