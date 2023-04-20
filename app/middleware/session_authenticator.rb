class SessionAuthenticator
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # check if the request is to log in or refresh the session
    if request.path_info == '/api/v1/login' || request.path_info == '/api/v1/refresh_session'
      # don't check session token for login and refresh_session requests
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
