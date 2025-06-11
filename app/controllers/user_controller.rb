class UserController < ApplicationController
  skip_before_action :authorize_request, only: [ :create ]

  # Somente admin: editar outro usuário
  before_action :set_user, only: [ :destroy ] # <- apenas se usa /users/:id

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Authenticated user: GET /me
  def me
    render json: current_user
  end

  # PATCH /me
  def update_me
    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Only admin, if using /users/:id
  def destroy
    @user.destroy!
    render json: { message: "Usuário deletado com sucesso", email: @user.email }, status: :ok
  end

  private

    def set_user
      @user = User.find(params.expect(:id))
    end

    def user_params
      params.expect(user: [ :email, :password, :adm ])
    end
end
