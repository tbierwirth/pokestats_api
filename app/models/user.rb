class User < ApplicationRecord
  before_create :generate_api_key
  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
  validates :password, confirmation: { case_sensitive: true }

  has_secure_password

  def generate_api_key
    self.api_key = SecureRandom.urlsafe_base64
  end
end
