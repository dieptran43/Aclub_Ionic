class FacebookIdentity < Identity

  def fetch_data
    if sufficient_info?
      begin
        facebook_user_data = graph.get_object('me', fields: [:id, :name, :email]).symbolize_keys
        facebook_user_data[:profile_picture] = graph.get_picture(facebook_user_data[:id], type: :large)
      rescue Koala::KoalaError => e
        self.errors.add(:base, I18n.t("base.api.third_party.error_when_fetching_user_info")) and return
      end
      if facebook_user_data.delete(:id).to_s == uid.to_s
        facebook_user_data
      else
        self.errors.add(:base, I18n.t("base.api.third_party.invalid_uid")) and return
      end
    else
      self.errors.add(:base, I18n.t("base.api.third_party.missing_parametters")) and return
    end
  end

  def fetch_accounts
    begin
      graph.get_object('me', fields: [:accounts])["accounts"]["data"]
    rescue
      []
    end
  end

  def crawl_facebook_data
    {
      website: get_website,
      description: get_description,
      photos: get_photos,
      hours: get_hours,
      location: get_locations
    }
  end

  def get_photos
    begin
      user = graph.get_object("me")
      graph.get_connections(user["id"], "photos/uploaded").map do |p|
        { url: graph.get_object(p["id"], fields: [:images])["images"].first["source"] }
      end
    rescue
    end
  end

  def get_more_facebook_photos
    begin
      get_photos.each do |photo|
        url = photo[:url]
        unless FacebookPhoto.exists?(venue: user, url: url) || url.nil?
          FacebookPhoto.create(venue: user, url: url)
        end
      end
    rescue
    end
  end

  def get_hours
    page_data["hours"].to_a.to_json
  end

  def get_website
    page_data["website"]
  end

  def get_description
    page_data["about"]
  end

  def get_locations
    @location ||= page_data["location"]
    begin
      { 
        longitude: @location["longitude"],
        latitude: @location["latitude"],
        full_address: "#{@location["street"]} #{@location["city"]}",
        city: @location["city"]
      }
    rescue
      { longitude: nil, latitude: nil, full_address: nil, city: nil }
    end
  end

  protected
  def sufficient_info?
    access_token.present?
  end

  def graph
    @graph_client ||= Koala::Facebook::API.new(access_token)
  end

  def page_data
    @page_data ||= graph.get_object('me', fields: [:tabs, :picture, :photos, :hours, :location, :website, :emails, :about])
  end
end
