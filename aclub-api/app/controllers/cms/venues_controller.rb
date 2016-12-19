module Cms
  class VenuesController < BaseController
    def index
      @venues = Venue.index_by_name(params[:query]).order('updated_at DESC').page(params[:page])
    end

    def new
      @venue = Venue.new
    end

    def create
      if venue = Venue.create(venue_params)
        redirect_to cms_venue_path(venue)
      end
    end

    def show
      @venue = Venue.find_by_id(params[:id])
      Api::VenueDetailsService.new(@venue).get_details
    end

    def destroy
      if venue = Venue.find_by_id(params[:id])
        venue.destroy
        redirect_to cms_venues_path
      end
    end

    def edit
      @venue = Venue.find_by_id(params[:id])
    end

    def update
      if venue = Venue.find_by_id(params[:id]) 
        venue.update_attributes(venue_params)
        redirect_to cms_venue_path(venue)
      end
    end

    def photos
      @venue = Venue.find_by_id(params[:venue_id])
      if @venue
        @google_place_images = @venue.google_place_images
        @facebook_photos = @venue.facebook_photos
      end
    end

    def reviews
      @venue = Venue.find_by_id(params[:venue_id])
      if @venue
        @reviews = @venue.reviews
      end
    end
    private
    def venue_params
      params.require(:venue).permit(
        :name, :description, :latitude, :longitude,
        :full_address, :formatted_phone_number, :website,
        images_attributes: [:id, :content, :_destroy]
      )
    end
  end
end
