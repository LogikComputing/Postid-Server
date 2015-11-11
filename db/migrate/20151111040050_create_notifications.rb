class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :from_id
      t.string :message
      t.integer :post_id
      t.integer :type
      t.boolean :viewed

      t.timestamps null: false
    end
  end
end
