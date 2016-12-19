class AuthenticationToken < ActiveRecord::Base
  belongs_to :user
  include Tokenable

  validates :token, uniqueness: true

end
