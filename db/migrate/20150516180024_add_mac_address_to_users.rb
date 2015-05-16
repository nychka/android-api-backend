class AddMacAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mac_address, :string
  end
  def self.down
    remove_column :users, :mac_address
  end
end
