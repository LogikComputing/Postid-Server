class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

      t.integer :user_id, null: false
      t.string :image_url, null: false
      t.integer :view_count, default: 0
      t.integer :heart_count, default: 0
      t.integer :smirk_count, default: 0
      t.integer :fire_count, default: 0
      t.string :created_ip_address, default: ''
      t.integer :likes, default: 0
      t.integer :likes_needed, default: 0
      t.boolean :flagged, default: false
      t.boolean :approved, default: false
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end