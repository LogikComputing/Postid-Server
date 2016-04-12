class CreateHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
