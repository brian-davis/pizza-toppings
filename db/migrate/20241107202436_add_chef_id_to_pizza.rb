class AddChefIdToPizza < ActiveRecord::Migration[7.2]
  def change
    remove_index :pizzas, :name

    add_reference :pizzas, :chef, null: false, foreign_key: { to_table: :users }
    add_index :pizzas, [:name, :chef_id], unique: true
  end
end
