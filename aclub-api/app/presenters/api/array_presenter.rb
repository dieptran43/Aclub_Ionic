module Api
  class ArrayPresenter
    attr_accessor :objects, :presenter, :options

    def initialize(objects, presenter, options={})
      self.objects = objects
      self.options = options
      self.presenter = presenter
    end

    def as_json(*)
      objects.map { |object| presenter.new(object, options).as_json }
    end
  end
end
