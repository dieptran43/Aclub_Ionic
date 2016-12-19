module Api
  class UsersController < BaseController
    before_action :authenticate_user!
    before_action :require_coupon!, only: :invitees

    def show
      render json: AuthorizedUserPresenter.new(current_user)
    end

    def update
      if has_params?([:user])
        update_service = UserService.new(current_user, user_params)

        if update_service.update
          render json: update_service.response_data
        else
          render json: update_service.errors, status: :unprocessable_entity
        end
      end
    end

    def available_coupons
      render json: ArrayPresenter.new(current_user.available_user_coupons, UserCouponPresenter)
    end

    def used_coupons
      render json: ArrayPresenter.new(current_user.used_user_coupons, UserCouponPresenter)
    end

    def invitees
      pending_invitees = ArrayPresenter.new(current_user.pending_invitees(@coupon), UserPresenter)
      accepted_invitees = ArrayPresenter.new(current_user.accepted_invitees(@coupon), UserPresenter)
      denied_invitees = ArrayPresenter.new(current_user.denied_invitees(@coupon), UserPresenter)
      render json: { pending_invitees: pending_invitees, accepted_invitees: accepted_invitees, denied_invitees: denied_invitees }
    end

    def friends
      if user = User.find_by(id: params[:id])
        followings = ArrayPresenter.new(user.following_users, UserPresenter)
        followers = ArrayPresenter.new(user.user_followers, UserPresenter)
        render json: { followings: followings, followers: followers }
      else
        render_errors(I18n.t("base.api.not_found"), :not_found)
      end
    end

    def email_registration
      update_service = UserService.new(current_user, params)
      if update_service.register_email_password
        VerificationEmailJob.perform_later(current_user.id)
        render json: update_service.response_data
      else
        render json: update_service.errors, status: :unprocessable_entity
      end
    end

    def email_verification
      update_service = UserService.new(current_user, params)
      if update_service.verify_email
        render json: update_service.response_data
      else
        render_errors("Invalid email verification token", :unauthorized)
      end
    end

    def resend_email_verification
      VerificationEmailJob.perform_later(current_user.id)
      head :ok
    end

    private
    def user_params
      params[:user].permit(:name, :phone, :email, :avatar, :password)
    end

    def require_coupon!
      @coupon = Coupon.find_by(id: params[:coupon_id])
      render_errors(I18n.t('base.api.not_found'), :not_found) unless @coupon
    end
  end
end
