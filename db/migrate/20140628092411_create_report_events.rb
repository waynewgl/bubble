class CreateReportEvents < ActiveRecord::Migration
  def change
    create_table :report_events do |t|
      t.string :event_id
      t.string :user_id
      t.string :reason

      t.timestamps
    end
  end
end
