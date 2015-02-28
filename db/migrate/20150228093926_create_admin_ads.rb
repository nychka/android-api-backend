class CreateAdminAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :name
      t.string :price
      t.integer :place_id
      t.string :photo

      t.timestamps
    end
    add_index :ads, :place_id
  end
  def self.down
    drop_table :ads
  end
end
