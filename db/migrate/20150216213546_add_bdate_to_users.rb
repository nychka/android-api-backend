class AddBdateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bdate, :date
  end
  def self.down
    remove_column :users, :bdate
  end
end
