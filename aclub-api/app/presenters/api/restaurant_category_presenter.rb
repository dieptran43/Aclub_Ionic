module Api
  class RestaurantCategoryPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        alias: object.alias,
        restaurant_count: object.restaurant_count,
        image: object.image.urls
      }
    end
  end
end
