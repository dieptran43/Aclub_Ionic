require 'open-uri'

module Api
  class ImageDownload
    attr_accessor :url, :targeting_model

    def initialize(url, targeting_model)
      self.url = url
      self.targeting_model = targeting_model
    end

    def download
      open("#{SecureRandom.hex(16)}.png", 'wb') do |file|
        file << open(url).read
        Image.create(content: file, object: targeting_model)
        File.delete(file)
      end
    end
  end
end