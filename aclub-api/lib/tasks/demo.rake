namespace :demo do
  desc "get data for demo"
  task get_user_age_range: :environment do
    p "-------starting crawl data for #{User.count} users----------"
    User.all.each do |u|
      client = Koala::Facebook::API.new(u.facebook_token)
      begin
        data = client.get_object('me', fields: [:age_range])
        u.update_attributes(age_range: data["age_range"])
      rescue
        p "-------user with id #{u.id} cannot be crawled----------"
      end
    end
  end

  task get_google_place_detail: :environment do
    GooglePlaceCrawlJob.perform_later
  end
end