class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, allow_nil: true

  has_secure_password
  has_one_attached :profile_picture

  attribute :other_names, :string
  attribute :session_token, :string
  attribute :session_token_expiry, :datetime

  def generate_session_token
    loop do
      token = SecureRandom.hex(20)
      unless User.exists?(session_token: token)
        self.session_token = token
        self.session_token_expiry = Time.now + 1.hour
        save!
        return token
      end
    end
  end

  def refresh_session_token_expiry
    self.session_token_expiry = Time.now + 1.hour
    self.save!
  end

  def self.expire_session_tokens
    where("session_token_expires_at <= ?", Time.now).update_all(session_token: nil, session_token_expires_at: nil)
  end

end
