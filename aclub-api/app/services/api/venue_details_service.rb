module Api
  class VenueDetailsService
    attr_accessor :venue

    def initialize(venue)
      self.venue = venue
    end

    def get_details
      if should_crawl_data?
        crawled_venue = GooglePlaceService.get_venue_details(venue.google_place_id)
        Venue.transaction do
          venue.update_attributes(
            full_address: crawled_venue.formatted_address,
            formatted_phone_number: crawled_venue.formatted_phone_number,
            website: crawled_venue.website,
            opening_hours: crawled_venue.opening_hours.nil? ? nil : crawled_venue.opening_hours["weekday_text"].to_json,
            crawled?: true
          )

          crawled_venue.reviews.map do |review|
            Review.create(text: review.text, venue: venue, author_name: review.author_name, rating: review.rating)
          end

          crawled_venue.photos.map do |photo|
            GooglePlaceImage.create(url: GooglePlaceService.construct_image_url(photo.photo_reference), venue: venue)
          end
        end
      end

      VenuePresenter.new(venue.reload)
    end

    private
    def should_crawl_data?
      !venue.crawled? && venue.google_place_id
    end
  end
end