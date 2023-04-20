class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { message: "Login successful!" }
    else
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    current_user.invalidate_session_token
    cookies.delete(:session_token)
    render json: { message: 'Logout successful' }
  end
end
