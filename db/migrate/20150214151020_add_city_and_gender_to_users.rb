class AddCityAndGenderToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :city, :string
    add_column :users, :gender, :integer, limit: 1
    add_index :users, :city
  end
  def self.down
    remove_index :users, :city
    remove_column :users, :city
    remove_column :users, :gender
  end
end
