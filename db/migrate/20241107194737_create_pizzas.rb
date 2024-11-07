class CreatePizzas < ActiveRecord::Migration[7.2]
  def change
    create_table :pizzas do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :pizzas, :name, unique: true
  end
end