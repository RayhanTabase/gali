class ApplicationController < ActionController::API
  before_action :authorize, unless: :guest_access?

  def authorize
    render json: { message: 'Please log in to access' }, status: :unauthorized unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def create_user_action?
    params[:controller] == 'users' && params[:action] == 'create'
  end

  def login_user_action?
    params[:controller] == 'auth' && params[:action] == 'login'
  end

  def guest_access?
    params[:controller] == 'users' && params[:action] == 'create' ||
      params[:controller] == 'auth' && params[:action] == 'login'
  end

end
