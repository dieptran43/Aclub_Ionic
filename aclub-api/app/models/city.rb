class City < ActiveRecord::Base
  has_many :districts
  has_many :areas
  has_many :restaurants
end