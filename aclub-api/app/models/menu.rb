class Menu < ActiveRecord::Base
  belongs_to :menu_category
  belongs_to :owner, polymorphic: true
  has_many :menu_components
  mount_uploader :image, ImageUploader
  accepts_nested_attributes_for :menu_components, allow_destroy: true

  def components_count
    menu_components.count
  end

  def self.get_by_owner_fanpage_id(page_id)
    @owner = Admin.joins('join identities on admins.id = identities.user_id').where('identities.uid = ? and admins.role = ?', page_id, 'owner')[0]
    @list_all_owner_menu = Menu.where('owner_id = ?', @owner.id).order('created_at DESC')
  end

  def category_name
    menu_category.try(:name)
  end
end
