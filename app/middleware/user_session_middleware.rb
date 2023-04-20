class UserSessionMiddleware
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env["HTTP_X_USER_SESSION_TOKEN"].present?
      user = User.find_by(session_token: env["HTTP_X_USER_SESSION_TOKEN"])
      
      if user.present? && user.session_token_expiry > Time.now
        env["X_CURRENT_USER"] = user
      end
    end
    
    @app.call(env)
  end
end