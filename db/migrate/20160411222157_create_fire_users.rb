class CreateFireUsers < ActiveRecord::Migration
  def change
    create_table :fire_users do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
