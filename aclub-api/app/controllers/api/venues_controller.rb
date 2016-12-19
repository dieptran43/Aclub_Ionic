module Api
  class VenuesController < BaseController
    before_action :require_venue!, only: [:show]

    #Accepted params
    # required query: 'venue_name',
    # optional :latitude, :longitude, :radius (in metter)
    def index
      venues = Venue.search_and_update(venue_search_params)
      render json: ArrayPresenter.new(venues, VenuePresenter)
    end

    def show
      impressionist(@venue, Venue::VIEW)
      render json: VenueDetailsService.new(@venue).get_details
    end

    #Accepted params
    # optional :latitude, :longitude, :radius (in metter)
    def popular_restaurants
      venues = Venue.popular_restaurants(venue_search_params)
      render json: ArrayPresenter.new(venues, VenuePresenter)
    end

    private
    def venue_search_params
      params.permit(:query, :latitude, :longitude, :radius, :page)
    end

    def require_venue!
      if has_params?([:id])
        @venue = Venue.find_by(id: params[:id])
        render_errors(I18n.t('base.api.not_found'), :not_found) unless @venue
      end
    end
  end
end
