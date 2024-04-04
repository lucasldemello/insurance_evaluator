class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.integer :year, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
