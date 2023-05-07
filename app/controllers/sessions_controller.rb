class SessionsController < ApplicationController
  def create
    puts params
    user = User.find_by(email: params[:email])
    puts "1"
    if user && user.authenticate(params[:password])
      puts "2"
      session[:user_id] = user.id
      session_token = user.generate_session_token
      puts session_token
      # cookies[:session_token] = {
      #   value: session_token,
      #   expires: user.session_token_expiry,
      #   httponly: true
      # }
      render json: { message: 'Logged in successfully', session_token: session_token }, status: :ok
    else
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    current_user.invalidate_session_token
    cookies.delete(:session_token)
    session[:user_id] = nil
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  def refresh_session
    current_user.refresh_session_token_expiry
    head :no_content
  end
end
