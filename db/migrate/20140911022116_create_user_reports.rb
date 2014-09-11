class CreateUserReports < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.string :user_id
      t.string :stranger_id
      t.string :reason

      t.timestamps
    end
  end
end
