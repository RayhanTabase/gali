class ApplicationController < ActionController::API
  before_action :authorize, unless: :can_access?

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

  def can_access?
    params[:controller] == 'users' && params[:action] == 'create' ||
    params[:controller] == 'users' && params[:action] == 'show' ||  #remove this condition
    params[:controller] == 'sessions' && params[:action] == 'create'
  end
end
