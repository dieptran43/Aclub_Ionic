class District < ActiveRecord::Base
  has_many :areas
  has_many :restaurants
  belongs_to :cities
end