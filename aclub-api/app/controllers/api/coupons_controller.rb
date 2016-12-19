module Api
  class CouponsController < BaseController
    before_filter :require_location, only: [:hot_and_nearby, :most_nearby]
    
    def index
      render json: ArrayPresenter.new(Coupon.includes(restaurant: [:restaurant_category]).available.page(params[:page]), CouponPresenter)
    end

    def show
      coupon = Coupon.find_by(id: params[:id])
      if coupon.present?
        impressionist(coupon, message: Coupon::VIEW)
        render json: CouponPresenter.new(coupon)
      else
        render_errors(I18n.t("base.api.not_found"), :not_found)
      end
    end

    def most_nearby #cat =(1,2,3,5)
      most_nearby_coupons = Coupon.available.most_nearby_cat(params[:latitude], params[:longitude]).page(params[:page]).sort_by(&:distance)
      render json: ArrayPresenter.new(most_nearby_coupons, CouponPresenter)
    end

    def best_price  #cat =(54)
      best_price_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_price.page(params[:page]).sort_by(&:distance)
      render json: ArrayPresenter.new(best_price_coupons, CouponPresenter)
    end

    def best_service #cat =(12)
      best_service_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_service.page(params[:page]).sort_by(&:distance)
      render json: ArrayPresenter.new(best_service_coupons, CouponPresenter)
    end

    def best_bar #cat =(4,43)
      best_bar_coupons = Coupon.available.most_nearby(params[:latitude], params[:longitude]).best_bar.page(params[:page]).sort_by(&:distance)
      render json: ArrayPresenter.new(best_bar_coupons, CouponPresenter)
    end
    def hot_and_nearby
      hot_nearby_coupons = Coupon.available.hot_and_nearby(params[:latitude], params[:longitude])
      render json: ArrayPresenter.new(hot_nearby_coupons, CouponPresenter)
    end    
   
  end
end
