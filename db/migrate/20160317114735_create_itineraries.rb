class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.text :name
      t.integer :home_airport_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
