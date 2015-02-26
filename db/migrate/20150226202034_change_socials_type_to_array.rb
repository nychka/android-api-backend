class ChangeSocialsTypeToArray < ActiveRecord::Migration
  def self.up
    remove_column :users, :socials
    add_column :users, :links, :string, array: true
  end
  def self.down
    remove_column :users, :links
    add_column :users, :socials, :hstore
  end
end
