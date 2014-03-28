class CreateReservables < ActiveRecord::Migration
  def change
    create_table :reservables do |t|
      t.string :description

      t.timestamps
    end
  end
end
