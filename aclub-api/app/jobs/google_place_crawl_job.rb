class GooglePlaceCrawlJob < ActiveJob::Base
  def perform
    Venue.all.each do |v|
      Api::VenueDetailsService.new(v).get_details
    end
  end
end