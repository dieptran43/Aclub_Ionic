module Api
  class ReviewPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        text: object.text,
        rating: object.rating,
        author_name: object.author_name,
        user_id: object.user_id
      }
    end
  end
end
