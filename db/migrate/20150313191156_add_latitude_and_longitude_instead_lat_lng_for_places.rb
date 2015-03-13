class AddLatitudeAndLongitudeInsteadLatLngForPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :lat
    remove_column :places, :lng
    add_column    :places, :latitude,  :float
    add_column    :places, :longitude, :float
  end
end
