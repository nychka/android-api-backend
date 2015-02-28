class Admin::PlacesController < ApplicationController
  before_action :set_admin_place, only: [:show, :edit, :update, :destroy]

  # GET /admin/places
  def index
    @admin_places = Admin::Place.all
  end

  # GET /admin/places/1
  def show
  end

  # GET /admin/places/new
  def new
    @admin_place = Admin::Place.new
  end

  # GET /admin/places/1/edit
  def edit
  end

  # POST /admin/places
  def create
    @admin_place = Admin::Place.new(admin_place_params)

    if @admin_place.save
      redirect_to @admin_place, notice: 'Place was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/places/1
  def update
    if @admin_place.update(admin_place_params)
      redirect_to @admin_place, notice: 'Place was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/places/1
  def destroy
    @admin_place.destroy
    redirect_to admin_places_url, notice: 'Place was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_place
      @admin_place = Admin::Place.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_place_params
      params.require(:admin_place).permit(:name, :phone, :lng, :lat)
    end
end
