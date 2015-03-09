class Admin::AdsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_ad, only: [:show, :edit, :update, :destroy]
  before_action :set_place, only: [:create]

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
    @place = Place.new
  end

  # GET /admin/ads/1/edit
  def edit
  end

  # POST /admin/ads
  def create
    @ad = @place.ads.build(ad_params)
    if @ad.save
      redirect_to [:admin, @ad], notice: 'Ad was successfully created.'
    else
      render(action: :new)
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
    def set_place
      if ad_params[:place_id] and not ad_params[:place_id].empty?
        @place = Place.find(ad_params[:place_id])
      else
        @place = Place.new(place_params)
        @ad = Ad.new(ad_params)
        render(action: :new) and return unless @place.save
      end
    end
    # Only allow a trusted parameter "white list" through.
    def ad_params
      params.require(:ad).permit(:name, :price, :photo, :place_id)
    end
    def place_params
      params.require(:place).permit(:name, :phone, :lat, :lng)
    end 
end
