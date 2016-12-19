class FacebookFanpage < ActiveRecord::Base
  belongs_to :admin
  has_many :identities, as: :user, dependent: :destroy
  has_many :restaurants, as: :owner
  has_many :restaurant_wait_list_reviews

  def facebook_link
    "https://www.facebook.com/#{identities.first.try(:uid)}"
  end
end
