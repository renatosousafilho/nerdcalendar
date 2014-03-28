class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :start_at
      t.date :end_at
      t.references :reservable, index: true

      t.timestamps
    end
  end
end
