class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :password_digest
      t.string :auth_token
      t.string :customer_number
      t.string :customer_api_token

      t.timestamps
    end

    add_index :customers, :email, unique: true
    add_index :customers, :auth_token, unique: true
  end
end
