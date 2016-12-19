module Api
  class Presenter
    attr_accessor :object, :options

    def initialize(object, options={})
      self.object = object
      self.options = options
    end
  end
end
