module Api
  class RestaurantPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        city: object.city.try(:name),
        district: object.district.try(:name),
        area: object.area.try(:name),
        restaurant_category: object.restaurant_category.try(:name),
        alias: object.alias,
        name: object.try(:name),
        address: object.try(:address),
        #logo_image: object.profile_image_url,
        logo_image: object.logo_image_url,
        phone: object.phone,
        lat: object.lat,
        lon: object.lon,
        images: object.try(:all_images),
        menus: ArrayPresenter.new(object.menus, MenuPresenter).as_json,
        comments_count: object.comments_count,
        average_rating: object.average_rating,
        price_range: object.formatted_price_range,
        coupons: ArrayPresenter.new(object.coupons, CouponInformationPresenter).as_json,
        distance: object.try(:distance)
      }
    end
  end
end
