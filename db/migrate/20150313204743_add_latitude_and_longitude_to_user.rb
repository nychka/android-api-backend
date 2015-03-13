class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :phone, :string

    add_index :users, [:latitude, :longitude], name: 'user_coordinates'
  end
  def self.down
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :phone

    remove_index :users, name: 'user_coordinates'
  end
end
