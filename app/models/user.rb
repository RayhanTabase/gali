class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password
  has_one_attached :profile_picture

  attribute :other_names, :string

  def refresh_session_token_expiry
    self.session_token_expiry = Time.now + 1.hour
    self.save!
  end

  def self.expire_session_tokens
    where("session_token_expires_at <= ?", Time.now).update_all(session_token: nil, session_token_expires_at: nil)
  end

end
