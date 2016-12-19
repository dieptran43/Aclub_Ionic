class Area < ActiveRecord::Base
  has_many :restaurants
  belongs_to :city
  belongs_to :district
end