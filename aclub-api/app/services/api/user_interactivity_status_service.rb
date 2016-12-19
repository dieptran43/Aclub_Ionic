module Api
  class UserInteractivityStatusService
    attr_accessor :user, :phones, :following_users, :not_following_users

    def initialize(user, phones)
      self.user = user
      self.phones = phones
    end

    def process
      phones.delete(user.phone)
      existing_users = User.where(phone: phones)
      self.following_users = User.where(id: user.follows.where(followable: existing_users).pluck(:followable_id))
      self.not_following_users = existing_users - following_users
    end

    def response_data
      {
        'followings': ArrayPresenter.new(following_users, UserPresenter),
        'not_followings': ArrayPresenter.new(not_following_users, UserPresenter)
      }
    end
  end
end