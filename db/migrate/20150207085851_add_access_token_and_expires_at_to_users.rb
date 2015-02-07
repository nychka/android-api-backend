class AddAccessTokenAndExpiresAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :access_token, :string
    add_index	 :users, :access_token, unique: true, using: 'btree'
    add_column :users, :expires_at, :datetime
  end
  def self.down
  	remove_column :users, :access_token
  	remove_column :users, :expires_at
  end
end
