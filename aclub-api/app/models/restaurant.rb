class Restaurant < ActiveRecord::Base
  include PgSearch
  include Commentable
  DEFAULT_AVERAGE_RATING = 5
  pg_search_scope :search_by_name, against: :name
  paginates_per 20
  belongs_to :city
  belongs_to :district
  belongs_to :area
  belongs_to :restaurant_category
  belongs_to :owner, polymorphic: true
  has_many :foody_images
  has_many :foody_comments
  has_many :coupons, dependent: :destroy
  has_many :menus, as: :owner
  has_many :restaurant_wait_list_reviews
  has_many :images, as: :object, dependent: :destroy
  
  delegate :urls, to: :profile_image, prefix: false
  mount_uploader :profile_image, ImageUploader

  accepts_nested_attributes_for :menus, allow_destroy: true
  acts_as_mappable  :default_units => :kms,
                    :default_formula => :flat,
                    :distance_field_name => :distance,
                    :lat_column_name => :lat,
                    :lng_column_name => :lon
  
  #acts_as_mappable through :restaurant_category
  
  VIEW = 'view'
  is_impressionable
  commentable
  CHECK_BOX_LIST = [
    [:should_reserve_table, 'Nên đặt trước'],
    [:delivery, 'Có giao hàng'],
    [:bring_home, 'Cho mua về'],
    [:has_wifi, 'Có wifi'],
    [:has_kid_zone, 'Có chỗ chơi cho trẻ em'],
    [:has_table_outside, 'Có bàn ngoài trời'],
    [:has_private_room, 'Có phòng riêng'],
    [:has_air_conditioner, 'Có máy lạnh'],
    [:has_scard_payment, 'Trả bằng thẻ: Visa/Master'],
    [:has_karaoke, 'Có karaoke'],
    [:has_free_motobike_parking, 'Giữ xe máy miễn phí'],
    [:give_tip, 'Tip cho nhân viên'],
    [:has_car_parking, 'Có chỗ đậu ôtô'],
    [:has_smoking_area, 'Có khu vực hút thuốc'],
    [:has_member_card, 'Có thẻ thành viên'],
    [:has_offical_receipt, 'Có xuất hóa đơn đỏ'],
    [:has_reference_support, 'Có hỗ trợ hội thảo'],
    [:has_heater, 'Có lò sưởi'],
    [:has_disable_support, 'Có hỗ trợ người khuyết tật'],
    [:has_football_screen, 'Có chiếu bóng đá'],
    [:has_live_music, 'Có nhạc sống']
  ]

  TEXT_FIELDS = [
    [:description, 'Miêu tả'],
    [:food_menu, 'Phục vụ món: (tên món)'],
    [:open_at, 'Giờ mở cửa'],
    [:close_at, 'Giờ dong cửa'],
    [:extra_fee, 'Phí dịch vụ tính thêm:'],
    [:time_to_book_a_table, 'Đặt bàn trước: (vi du Khoảng 3 - 5 phút)'],
    [:website, 'Website'],
    [:facebook_url, 'Facebook']
  ]
  
  NUMBER_FIELDS = [
    [:capacity, 'Người lớn(Có chỗ cho trẻ em)']
  ]

  LIST_FIELDS = [
    PRICE_RANGE = [:price_range, 'Mức giá', ['Dưới 200k', 'Từ 200 - 500k', 'từ 500 - 1triệu', 'trên 1 triệu']],
    suitable_time = [:suitable_time, 'Thích hợp', ['Buổi sáng', 'Buổi trưa', 'Buổi xế', 'Buổi tối']],
    FOOD_STYLE = [:food_style, 'Phong cách ẩm thực:', ['Châu Á', 'Tây Âu', 'Trung quốc']],
    USING_PURPOSE = [:using_purpose, 'Mục đích sử dụng:', ['Đãi tiệc', 'Ăn gia đình', 'Hẹn hò', 'Họp nhóm', 'Tiếp khách']]
  ]

  PRICE_RANGE_TEXT = {
    'Dưới 200k' => '$',
    'Từ 200 - 500k' => '$$',
    'từ 500 - 1triệu' => '$$$',
    'trên 1 triệu' => '$$$$'
  }
  
  def self.restaurant_catgory(id, latitude, longitude, page)
    where(restaurant_category_id: id).within(90000,:units => :kms, origin: [latitude, longitude]).order('distance asc').page(page)
  end
  
  def logo_image_url
    #code
    @str = "#{profile_image_url}"
    @id = "#{id}"
    if @str.include? "https://aclub-production.s3.amazonaws.com/uploads/"
     @str["https://aclub-production.s3.amazonaws.com/uploads/"] = "https://aclub-development.s3.amazonaws.com/uploads/restaurant/profile_image/" + @id  + "/"
    end
    return @str
  end

  def count_available_coupons
    coupons.available.count
  end

  def self.get_index(params)
    restaurants = index_by_name(params[:query])
    if params[:restaurant_category_id]
      restaurants = where(restaurant_category_id: params[:restaurant_category_id])
    end
    restaurants.page(params[:page]).includes(:foody_images, :area, :city, :district, :restaurant_category, :coupons, menus: [:menu_components])
  end

  def self.index_by_name(query)
    query.nil? ? all : search_by_name(query)
  end

  def all_images
    (foody_images + images.map(&:content)).map { |image| { thumb: image.url, origin: image.url } }
  end

  def images_count
    foody_images.count + images.count
  end

  def comments_count
    foody_comments.count + comments.count
  end
  
  def all_comments
    rating = average_rating || DEFAULT_AVERAGE_RATING
    Comment.transaction do
      foody_comments.each do |foody_comment|
        Comment.create(commentable: self, content: "#{foody_comment.title}: #{foody_comment.message}", rate: rating)
        foody_comment.destroy
      end
    end
    comments
  end

  def formatted_price_range
    PRICE_RANGE_TEXT[price_range]
  end
end
