module ApplicationHelper
  def formatted_index(form)
    begin
      (form.options[:child_index] + 1).to_s
    rescue
      form.options[:child_index].to_s
    end
  end

  def venue_image_tag(venue, form)
    begin
      content_tag :div, id: "image-preview-#{form.options[:child_index]}" do
        image_tag venue.images[form.options[:child_index]].content.url
      end
    rescue
      nil
    end
  end

  def user_avatar(user)
    image_url = user.avatar.url || user.facebook_image_url
    image_tag(image_url)
  end

  def vietnamese_status(status)
    t("cms.coupons.#{status}")
  end

  def opening_hours_tag(opening_hours)
    begin
      hours = JSON.parse(opening_hours)
      content_tag :ul, class: 'opening-hours' do
        hours.each do |hour|
          concat(content_tag :li, hour.to_s)
        end
      end
    rescue
      content_tag :div, class: 'opening-hours' do
        I18n.t("cms.venues.no_opening_hours")
      end
    end
  end

  def average_rating(venue)
    venue.reviews.count == 0 ? "Average Rating: 0" : "Average Rating: #{venue.reviews.pluck(:rating).inject(0) { |sum, x| sum + x.to_i }/venue.reviews.count}"
  end

  def voucher_page_list_class(index)
    if index == 14 || index == 11
      "li-50"
    end 
  end
end
