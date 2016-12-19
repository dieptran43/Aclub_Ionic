# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  #def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

   def cache_dir
    #'/tmp/UPHINH-cache'
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
   end
  version :thumb do
    process resize_to_limit: [200,200]
  end

  def urls
    if file.present?
      {
        thumb: url(:thumb),
        origin: url
      }
    else
      {}
    end
  end

end
