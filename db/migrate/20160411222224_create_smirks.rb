class CreateSmirks < ActiveRecord::Migration
  def change
    create_table :smirks do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
