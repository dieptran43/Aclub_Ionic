module Cms
  class CouponsController < BaseController
    def index
      @coupons = Coupon.order('updated_at DESC').page(params[:page])
    end

    def new
      @page_title = t('cms.coupons.title')
      @coupon = Coupon.new
    end

    def create
      if coupon = Coupon.create(coupon_params)
        redirect_to cms_coupon_path(coupon)
      end
    end

    def show
      @coupon = Coupon.find_by_id(params[:id])
    end

    def destroy
      if coupon = Coupon.find_by_id(params[:id])
        coupon.destroy
        redirect_to cms_coupons_path
      end
    end

    def edit
      @coupon = Coupon.find_by_id(params[:id])
    end

    def update
      if coupon = Coupon.find_by_id(params[:id])
        coupon.update_attributes(coupon_params)
        redirect_to cms_coupon_path(coupon)
      end
    end

    private
    def coupon_params
      params.require(:coupon).permit(
        :description, :venue_id, :image, :restaurant_id,
        :end_date, :start_date, :required_minimum_invitees,
        :short_description, :quantity, :priority, :number_of_free_volka,
        :cash_discount, :bill_discount, :food_discount
      )
    end
  end
end
