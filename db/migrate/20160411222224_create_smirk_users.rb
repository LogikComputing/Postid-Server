class CreateSmirkUsers < ActiveRecord::Migration
  def change
    create_table :smirk_users do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
