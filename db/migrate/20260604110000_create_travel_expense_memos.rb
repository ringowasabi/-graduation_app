class CreateTravelExpenseMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :travel_expense_memos do |t|
      t.references :destination, null: false, foreign_key: true
      t.string :departure_place, null: false
      t.string :arrival_place, null: false
      t.integer :one_way_fare, null: false

      t.timestamps
    end
  end
end
