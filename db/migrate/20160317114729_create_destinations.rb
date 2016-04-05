class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.text :name
      t.integer :itinerary_id
      t.integer :airport_id
      t.boolean :home_airport      
      t.integer :order
      t.integer :num_of_days

      t.timestamps null: false
    end
  end
end
