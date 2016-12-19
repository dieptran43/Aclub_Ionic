module Tokenable
  extend ActiveSupport::Concern

  included do
    before_save :ensure_token
  end

  def ensure_token
    if token.blank?
      generate_token
    end
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.base64(32)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end