class Image < ActiveRecord::Base
  belongs_to :object, polymorphic: true
  mount_uploader :content, ImageUploader
end
