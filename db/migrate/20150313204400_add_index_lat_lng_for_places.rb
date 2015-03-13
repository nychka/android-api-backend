class AddIndexLatLngForPlaces < ActiveRecord::Migration
  def self.up
    add_index :places, [:latitude, :longitude], name: 'place_coordinates'
  end
  def self.down
    remove_index :places, name: 'place_coordinates'
  end
end
