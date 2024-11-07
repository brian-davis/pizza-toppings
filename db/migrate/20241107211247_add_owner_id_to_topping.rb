class AddOwnerIdToTopping < ActiveRecord::Migration[7.2]
  def change
    remove_index :toppings, :name
    add_reference :toppings, :owner, null: false, foreign_key: { to_table: :users }

    add_index :toppings, [:name, :owner_id], unique: true
  end
end
