class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.integer :user_id
      t.integer :marked_user_id
      t.timestamps
    end
    add_index :marks, [:user_id, :marked_user_id], name: 'marked_user'
  end
  def self.down
    drop_table :marks
  end
end
