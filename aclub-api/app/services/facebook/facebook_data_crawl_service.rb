module Facebook
  class FacebookDataCrawlService
    attr_accessor :facebook_fanpage

    def initialize(facebook_fanpage)
      self.facebook_fanpage = facebook_fanpage
    end

    def update_data(restaurant)
      restaurant.owner = facebook_fanpage
      restaurant.name = facebook_fanpage.try(:name)
      restaurant.website = facebook_data[:website] if facebook_data[:website]
      restaurant.description = facebook_data[:description] if facebook_data[:description]
      restaurant.address = facebook_data[:location][:full_address] if facebook_data[:location]
      restaurant.lat = facebook_data[:location][:latitude] if facebook_data[:location]
      restaurant.lon = facebook_data[:location][:longitude] if facebook_data[:location]
      restaurant.city = City.find_by_name(facebook_data[:location][:city]) if facebook_data[:location]
      restaurant.open_at = open_at if facebook_data[:hours]
      restaurant.close_at = close_at if facebook_data[:hours]
      crawl_photo(restaurant) if facebook_data[:photos]
      restaurant
    end

    private
    def facebook_data
      begin
        @data ||= identity.crawl_facebook_data
      rescue
        @data = {}
      end
    end

    def identity
      @identity ||= facebook_fanpage.identities.first
    end

    def hours_data
      @hours ||= JSON.parse(facebook_data[:hours])
    end

    def open_at
      hours_data.find { |hour| hour[0].include? ("open") }[1]
    end

    def close_at
      hours_data.find { |hour| hour[0].include? ("close") }[1]
    end

    def crawl_photo(restaurant)
      facebook_data[:photos].take(10).each do |photo|
        Api::ImageDownload.new(photo[:url], restaurant).download
      end
    end
  end
end