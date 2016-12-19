namespace :demo do
  desc "get data for demo"
  task get_profile_image: :environment do
    Restaurant.all.each do |restaurant|
      if url = restaurant.image
        open("#{SecureRandom.hex(16)}.png", 'wb') do |file|
          file << open(url).read
          restaurant.update_attributes(profile_image: file) unless restaurant.profile_image_url
          File.delete(file)
        end
        p "---create profile image for :  #{ restaurant.id } -----"
      end
    end
  end
end