class Admin::AdsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_ad, only: [:show, :edit, :update, :destroy]

  # GET /admin/ads
  def index
    @ads = Ad.all
  end

  # GET /admin/ads/1
  def show
  end

  # GET /admin/ads/new
  def new
    @ad = Ad.new
  end

  # GET /admin/ads/1/edit
  def edit
  end

  # POST /admin/ads
  def create
    @ad = Ad.new(ad_params)

    if @ad.save
      redirect_to [:admin, @ad], notice: 'Ad was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/ads/1
  def update
    if @ad.update(ad_params)
      redirect_to [:admin, @ad], notice: 'Ad was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/ads/1
  def destroy
    @ad.destroy
    redirect_to admin_ads_url, notice: 'Ad was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad
      @ad = Ad.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ad_params
      params.require(:ad).permit(:name, :price, :place_id, :photo)
    end
end
