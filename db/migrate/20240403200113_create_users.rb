class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :age, null: false
      t.integer :dependents, null: false
      t.integer :income, null: false
      t.string :marital_status, null: false
      t.integer :risk_questions, null: false, array: true, default: [0, 0, 0]

      t.timestamps
    end
  end
end
