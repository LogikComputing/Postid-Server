class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_hash, null: false
      t.string :token, default: ''
      t.integer :check_ins, default: 1
      t.integer :posts_created, default: 1
      t.string :last_ip_address, default: ''
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
