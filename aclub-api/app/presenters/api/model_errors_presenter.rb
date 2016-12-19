module Api
  class ModelErrorsPresenter < Presenter
    def as_json(*)
      {
        errors: object.errors.full_messages.join('. ')
      }
    end
  end
end
