class AddSocialsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :socials, :hstore
  end
  def self.down
    remove_column :users, :socials
  end
end
