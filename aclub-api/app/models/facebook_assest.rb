class FacebookAssest < ActiveRecord::Base
  belongs_to :venue
  has_one :identity, as: :user, dependent: :destroy
end
