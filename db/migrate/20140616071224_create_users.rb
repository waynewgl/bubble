class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :major
      t.string :minor
      t.string :email
      t.string :account
      t.string :password
      t.string :nickname
      t.string :sex
      t.timestamps
    end
  end
end
