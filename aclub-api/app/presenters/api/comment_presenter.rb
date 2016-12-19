module Api
  class CommentPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        content: object.content,
        rate: object.rate,
        commenter: (UserPresenter.new(object.commenter).as_json if object.commenter),
        created_at: object.created_at
      }
    end
  end
end
