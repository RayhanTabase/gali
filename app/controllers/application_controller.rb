class ApplicationController < ActionController::API
  before_action :authorize

  def authorize
    render json: { message: 'Unauthorized' }, status: :unauthorized unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
