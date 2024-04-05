class CreateInsuranceScores < ActiveRecord::Migration[7.0]
  def change
    create_table :insurance_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.string :insurance_type, null: false
      t.boolean :ineligible, default: false
      t.integer :score, default: 0
      t.string :score_description, null: false

      t.timestamps
    end
  end
end
