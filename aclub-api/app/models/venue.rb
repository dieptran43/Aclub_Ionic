class Venue < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_any_word, against: :name, :using => {:tsearch => {:any_word => true}}
  paginates_per 20

  has_many :google_place_images, dependent: :destroy
  has_many :images, as: 'object'
  has_many :reviews, dependent: :destroy
  has_many :identities, as: :user, dependent: :destroy
  has_many :facebook_assests, dependent: :destroy
  has_many :facebook_photos, dependent: :destroy
  belongs_to :admin

  UNIQUENESS_RADIUS = 0.03 #km
  DEFAULT_SEARCH_RADIUS = 50000.0 #meter
  DEAFAULT_POPULAR_RADIUS = 50000 #meter
  VIEW = 'view'
  RESTAURANT_SECTION = 'food'
  # for future impression checkin CHECKIN = 'checkin'

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :google_place_images, allow_destroy: true
  accepts_nested_attributes_for :facebook_photos, allow_destroy: true

  is_impressionable
  acts_as_mappable  :default_units => :kms,
                    :default_formula => :flat,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude

  scope :highest_rating, -> {
    joins(:reviews).group("venues.id").
    select("venues.*, AVG(reviews.rating) AS average_rating").
    order("AVG(reviews.rating) DESC")
  }

  scope :not_owned_by_others, -> (admin_id) {
    where("admin_id is NULL OR admin_id = ?", admin_id)
  }

  def self.search_and_update(params)
    latitude = params[:latitude]
    longitude = params[:longitude]
    query = params[:query].to_s
    radius = (params[:radius] || DEFAULT_SEARCH_RADIUS).to_f

    if latitude && longitude
      venues = GooglePlaceService.search(latitude, longitude, query, radius)
      venues.each { |venue| find_or_create_within(venue) }
      internal_database_venue(query, latitude, longitude, radius/1000.0).page(params[:page])
    else
      index_by_name(query).includes(:google_place_images, :images).page(params[:page])
    end
  end

  def self.internal_database_venue(query, latitude, longitude, radius)
    index_by_name(query).within(radius, origin: [latitude, longitude]).includes(:google_place_images, :images, :reviews)
  end

  def self.popular_restaurants(params)
    latitude = params[:latitude]
    longitude = params[:longitude]
    radius = (params[:radius] || DEAFAULT_POPULAR_RADIUS).to_f/1000.0

    if latitude && longitude
      within(radius, origin: [latitude, longitude])
        .joins("LEFT JOIN impressions on venues.id = impressions.impressionable_id")
        .group('venues.id').order('count(impressions.impressionable_id) DESC')
        .page(params[:page])
    else 
      joins("LEFT JOIN impressions on venues.id = impressions.impressionable_id")
        .group('venues.id').order('count(impressions.impressionable_id) DESC')
        .page(params[:page])
    end
  end

  def self.find_or_create_within(venue)
    latitude = venue.lat
    longitude = venue.lng
    name = venue.name
    google_place_id = venue.place_id
    image_urls = venue.photos.map do |p|
      GooglePlaceService.construct_image_url(p.photo_reference)
    end
    recorded_veune = within(UNIQUENESS_RADIUS, origin: [latitude, longitude]).where('lower(name) = ?', name.downcase).first
    
    unless recorded_veune
      google_place_images_attributes = Venue.assign_google_place_images(image_urls)
      recorded_veune = create(
        name: name, latitude: latitude,
        longitude: longitude,
        google_place_id: google_place_id,
        google_place_images_attributes: google_place_images_attributes
      )
    end
    recorded_veune
  end

  def self.assign_google_place_images(urls)
    urls.map { |url| { url: url } }
  end

  def self.index_by_name(query=nil)
    query.present? ? search_any_word(query) : all
  end

  def image_urls
    if images.empty?
      google_place_images.map { |image| { thumb: image.url, origin: image.url } }
    else
      images.map { |image| image.content.urls }
    end
  end

  def owner_name
    admin.try(:name) || admin.email
  end

  def formatted_opening_hours
    JSON.parse(opening_hours) if opening_hours
  end
end
