class GooglePlaceService
  DEFAULT_TYPE = 'food'
  DEDAULT_KEY_WORDS = ['', 'ngon', 'Quán Ăn', 'Nhà hàng', 'beer']
  DEAFULT_RADIUS = 50000 #in meter which is maxmum radis for google place as well
  DEFAULT_ORDER = 'distance'
  @@google_place = GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

  def self.search(lat, long, name, radius)
    results = []
    radius = (radius || DEAFULT_RADIUS).to_i
    begin
      if name
        results = @@google_place.spots(lat, long, types: [DEFAULT_TYPE], keyword: name, radius: radius)
      else
        DEDAULT_KEY_WORDS.each do |keyword|
          results = results | @@google_place.spots(lat, long, types: [DEFAULT_TYPE], keyword: name, radius: radius, rankby: DEFAULT_ORDER)
        end
      end
      results
    rescue
      []
    end
  end

  def self.construct_image_url(reference)
    "https://maps.googleapis.com/maps/api/place/photo?photoreference=#{reference}&key=#{Rails.application.secrets.google_api_key}&sensor=false&maxwidth=640"
  end

  def self.get_venue_details(place_id)
    @@google_place.spot(place_id)
  end  
end