class UsersController < ApplicationController
  before_action :find_user, only: [:update, :destroy]

  def create
    user = User.new(user_params)
    user.password_digest = BCrypt::Password.create(params[:password])

    if user.save
      render json: user, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def show
    # render json: @user, status: :ok
    render json: User.all, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :other_names, :email, :password, :password_confirmation)
  end
  
  def find_user
    @user = User.find_by(id: params[:id])
    head :not_found unless @user
  end
end
