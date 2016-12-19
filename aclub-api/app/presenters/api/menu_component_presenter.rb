module Api
  class MenuComponentPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        content: object.content
      }
    end
  end
end
