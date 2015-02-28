class CreateAdminPlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.string :phone
      t.decimal :lng, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6

      t.timestamps
    end
  end
  def self.down
    drop_table :places
  end
end
