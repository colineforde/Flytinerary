class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.text :code
      t.text :name
      t.text :city
      t.text :country
      t.text :timezone
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
