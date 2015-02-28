class Admin::AdsController < ApplicationController
  before_action :set_admin_ad, only: [:show, :edit, :update, :destroy]

  # GET /admin/ads
  def index
    @admin_ads = Ad.all
  end

  # GET /admin/ads/1
  def show
  end

  # GET /admin/ads/new
  def new
    @admin_ad = Ad.new
  end

  # GET /admin/ads/1/edit
  def edit
  end

  # POST /admin/ads
  def create
    @admin_ad = Ad.new(admin_ad_params)

    if @admin_ad.save
      redirect_to @admin_ad, notice: 'Ad was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/ads/1
  def update
    if @admin_ad.update(admin_ad_params)
      redirect_to @admin_ad, notice: 'Ad was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/ads/1
  def destroy
    @admin_ad.destroy
    redirect_to admin_ads_url, notice: 'Ad was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_ad
      @admin_ad = Ad.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_ad_params
      params.require(:admin_ad).permit(:name, :price, :place_id, :photo)
    end
end
