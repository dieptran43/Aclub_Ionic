module Api
  class MenuCategoryPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name
      }
    end
  end
end
