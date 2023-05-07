require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

class SessionAuthenticator
  def initialize(app, except_paths = [])
    @app = app
    @except_paths = except_paths
  end

  def call(env)
    request = Rack::Request.new(env)

    # check if the request is to log in or create a new user
    if @except_paths.include?(request.path_info)
      @app.call(env)
    else
      # check session token for all other requests
      if request.cookies['session_token'].present?
        user = User.find_by_session_token(request.cookies['session_token'])
        if user.present?
          # set user in the request for future use
          env['user'] = user
          # refresh session token expiration time
          user.refresh_session_token_expiry
          # call the app
          @app.call(env)
        else
          # invalid session token
          [401, {'Content-Type' => 'application/json'}, [{error: 'Unauthorized'}.to_json]]
        end
      else
        # no session token provided
        [401, {'Content-Type' => 'application/json'}, [{error: 'Unauthorized'}.to_json]]
      end
    end
  end
end

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

Bundler.require(*Rails.groups)


module Gali
  class Application < Rails::Application
    
    # Initialize configuration defaults for originally generated Rails version.
    config.autoload_paths << "#{Rails.root}/app/middleware"
    config.load_defaults 7.0


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    
    config.api_only = true

    # configure session
    config.middleware.use ActionDispatch::Session::CookieStore
    Rails.application.config.session_store :cookie_store, key: '_gali_session'
    # Rails.application.config.middleware.use SessionAuthenticator
    # Rails.application.config.middleware.use UserSessionMiddleware
  end
end
