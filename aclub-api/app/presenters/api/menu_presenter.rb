module Api
  class MenuPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        price: object.price,
        image: object.image.urls,
        category: (MenuCategoryPresenter.new(object.menu_category).as_json if object.menu_category),
        components: ArrayPresenter.new(object.menu_components, MenuComponentPresenter).as_json
      }
    end
  end
end
