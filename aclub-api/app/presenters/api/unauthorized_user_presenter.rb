module Api
  class UnauthorizedUserPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        phone: object.phone,
      }
    end
  end
end
