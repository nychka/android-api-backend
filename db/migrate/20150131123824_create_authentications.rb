class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id, null: false
      t.string :provider, null: false
      t.string :auth_token, null: false
      t.string :refresh_token

      t.timestamps
    end
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :auth_token], unique: true
  end
end
