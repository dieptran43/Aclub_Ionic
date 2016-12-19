class Partner < ActiveRecord::Base

  delegate :urls, to: :image, prefix: true
  mount_uploader :image, ImageUploader

end
