class CreateHeartUsers < ActiveRecord::Migration
  def change
    create_table :heart_users do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
