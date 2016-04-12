class CreateFires < ActiveRecord::Migration
  def change
    create_table :fires do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
