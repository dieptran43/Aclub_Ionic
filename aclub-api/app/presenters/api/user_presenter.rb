module Api
  class UserPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        email: object.email,
        phone: object.phone,
        avatar: object.avatar_urls,
        avatar1: object.avatar1,
      }
    end
  end
  
  
end
