every 1.hour do
  runner "User.expire_session_tokens"
end
