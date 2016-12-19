class MenuCategory < ActiveRecord::Base
  has_many :menus
  NAMES = [
    BREAKFIRST = "Ăn sáng",
    LUNCH = "Ăn trưa",
    DINNER = "Ăn tối"
  ]
end
