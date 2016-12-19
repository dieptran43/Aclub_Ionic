class FoodyImage < ActiveRecord::Base
  belongs_to :place
  belongs_to :album
end