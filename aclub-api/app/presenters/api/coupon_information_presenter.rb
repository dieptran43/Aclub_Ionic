module Api
  class CouponInformationPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        code: object.code,
        start_date: object.start_date,
        end_date: object.end_date,
        description: object.description,
        short_description: object.short_description,
        image: object.image_urls,
        required_minimum_invitees: object.required_minimum_invitees,
        quantity: object.quantity,
        comments_count: object.comments_count,
        usage_count: object.user_coupons.count,
        distance: object.try(:distance),
        average_rating: object.average_rating
      }
    end
  end
end
