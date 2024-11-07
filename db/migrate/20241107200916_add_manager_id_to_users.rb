class AddManagerIdToUsers < ActiveRecord::Migration[7.2]

  # rake db:migrate:reset
  def change
    add_reference :users, :manager, null: true, foreign_key: { to_table: :users }
  end
end
