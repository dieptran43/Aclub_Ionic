class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    if admin.admin?
      can :mange, Venue
      can :mange, Coupon
      can :mange, User
      can :mange, Admin
      can :mange, AdvertisingEvent
      can :mange, AdvertisingEvent
    else
      can :manage, Venue, admin_id: admin.id
      can [:read, :edit, :update], Coupon, venue: { admin_id: admin.id }
    end
  end
end
