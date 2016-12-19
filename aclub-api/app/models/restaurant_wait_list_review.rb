class RestaurantWaitListReview < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :facebook_fanpage
  enum status: { pending: 0, accepted: 1, denied: 2 }
  before_save :validate_restaurant_ownership

  private
  def validate_restaurant_ownership
    if restaurant.owner
      errors.add(:base, "Restaurant #{restaurant.name} is already owned by #{restaurant.owner.name}")
    end
  end
end
