User.destroy_all
Coupon.destroy_all
Venue.destroy_all
Admin.destroy_all
Restaurant.destroy_all
RestaurantCategory.destroy_all
FoodyImage.destroy_all
City.destroy_all
District.destroy_all
Area.destroy_all
star_bucks_venue = FactoryGirl.create(:venue, :star_bucks)
vuvuzela_venue = FactoryGirl.create(:venue, :vuvuzela)
highland_venue = FactoryGirl.create(:venue, :highland)

user_1 = FactoryGirl.create(:user, phone: '84969032266', password: '123123')
user_2 = FactoryGirl.create(:user, phone: '84969032261')
user_3 = FactoryGirl.create(:user, phone: '84969032262')

[user_1, user_2, user_3].each do |user|
  [star_bucks_venue, vuvuzela_venue, highland_venue].each do |venue|
    user.reviews.create(venue: venue, rating: rand(1..5))
  end
end

user_1.follow(user_2)
user_1.follow(user_3)

FactoryGirl.create(:client_application, name: 'iOS', token: 'b0bb724a0c6a6654742a6b667de939998ef70c6b2569516054a4ee')
FactoryGirl.create(:client_application, name: 'Android')

Admin.create(email: 'demo@admin.com', password: '123123', password_confirmation: '123123', role: Admin::ADMIN)
Admin.create(email: 'demo@owner.com', password: '123123', password_confirmation: '123123', role: Admin::OWNER)

City.create({"id"=>1, "alias"=>"ho-chi-minh", "name"=>"TP. HCM", "position"=>0})
District.create({"id"=>1, "city_id"=>1, "alias"=>"quan-1", "name"=>"Quận 1", "position"=>0})
Area.create({"id"=>1, "city_id"=>1, "district_id"=>1, "alias"=>"cho-ben-thanh", "name"=>"Chợ Bến Thành", "position"=>1})
RestaurantCategory.create({"id"=>1, "alias"=>"nha-hang", "name"=>"Nhà hàng", "position"=>0})

Restaurant.create({
  "id"=>1, "city_id"=>1, "district_id"=>1, "area_id"=>1,
  "restaurant_category_id"=>1, "alias"=>"star_bucks_venue",
  "name"=>"star_bucks_venue", "address"=>"26 & 27th Floor Rooftop, AB Tower, 76A Lê Lai",
  "image"=>"http://media.foody.vn/res/g1/1335/prof/s220/201573135324-web-avatar-sb.jpg",
  "phone"=>"(08) 3827 2372 - (08) 62 538 888",
  "lat"=>10.770537, "lon"=>106.694305
})

Restaurant.create({
  "id"=>2, "city_id"=>1, "district_id"=>1, "area_id"=>1,
  "restaurant_category_id"=>1, "alias"=>"vuvuzela_venue",
  "name"=>"vuvuzela_venue", "address"=>"26 & 27th Floor Rooftop, AB Tower, 76A Lê Lai",
  "image"=>"http://media.foody.vn/res/g1/1335/prof/s220/201573135324-web-avatar-sb.jpg",
  "phone"=>"(08) 3827 2372 - (08) 62 538 888",
  "lat"=>10.7695605, "lon"=>106.7000773, "fd_id"=>1335, "complete"=>1
})

Restaurant.create({
  "id"=>3, "city_id"=>1, "district_id"=>1, "area_id"=>1,
  "restaurant_category_id"=>1, "alias"=>"chill-sky-bar",
  "name"=>"vuvuzela_venue", "address"=>"26 & 27th Floor Rooftop, AB Tower, 76A Lê Lai",
  "image"=>"http://media.foody.vn/res/g1/1335/prof/s220/201573135324-web-avatar-sb.jpg",
  "phone"=>"(08) 3827 2372 - (08) 62 538 888",
  "lat"=>10.774579, "lon"=>106.700748
})

FoodyImage.create({"id"=>1, "restaurant_id"=>1, "album_id"=>4, "url"=>"http://media.foody.vn/res/g1/1/s/0000000308.jpeg"} )
FoodyImage.create({"id"=>2, "restaurant_id"=>2, "album_id"=>4, "url"=>"http://media.foody.vn/res/g1/1/s/0000000308.jpeg"} )
FoodyImage.create({"id"=>3, "restaurant_id"=>3, "album_id"=>4, "url"=>"http://media.foody.vn/res/g1/1/s/0000000308.jpeg"} )
FactoryGirl.create(:coupon, restaurant_id: 1)
FactoryGirl.create(:coupon, restaurant_id: 2)
FactoryGirl.create(:coupon, restaurant_id: 3)