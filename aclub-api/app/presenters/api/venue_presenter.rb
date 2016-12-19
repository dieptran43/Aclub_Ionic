module Api
  class VenuePresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        description: object.description,
        longitude: object.longitude,
        latitude: object.latitude,
        full_address: object.full_address,
        categories: [], #temporarily removed from the system
        website: object.website,
        formatted_phone_number: object.formatted_phone_number,
        opening_hours: object.formatted_opening_hours,
        images: object.image_urls,
        average_rating: object.try(:average_rating)
      }
    end
  end
end
