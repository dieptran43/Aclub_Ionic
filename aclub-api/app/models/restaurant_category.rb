class RestaurantCategory < ActiveRecord::Base
  has_many :restaurants
  mount_uploader :image, ImageUploader
  NEARBY_DISTANCE = 5
  

  def restaurant_count
    #this will be change later when table 'places' is renamed to restaurants later 
    restaurants.count
  end
  
  def self.near_by_location(latitude, longitude, id)
    joins(:restaurants).where('restaurant_categories.id =' + id)
  end
  
end