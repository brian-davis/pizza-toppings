class Pizza < ApplicationRecord
  validates :chef_id, presence: true
  validate :chef_role
  validates :name, presence: true, uniqueness: { scope: :chef_id }
  validate :unique_toppings

  belongs_to :chef, class_name: "User", foreign_key: :chef_id

  has_many :pizza_toppings, dependent: :destroy
  has_many :toppings, through: :pizza_toppings

  accepts_nested_attributes_for :pizza_toppings, allow_destroy: true

  def topping_list
    toppings.pluck(:name).sort.to_sentence
  end

  private

  def chef_role
    if self.chef && !self.chef.role_chef?
      self.errors.add(:base, "Associated User must have chef role")
    end
  end

  # return a list of sorted lists of topping ids, per pizza by same chef
  def aggregate_sibling_pizza_topping_ids
    return [] if self.chef_id.nil?

    # # unoptimized:
    # return self.chef.pizzas.where.not(id: self.id).map { |pizza| pizza.topping_ids.sort.join(", ") }

    # optimized:

    where_clause = if self.id.present?
      "WHERE (users.id = #{self.chef_id}) AND (pizzas.id != #{self.id})"
    else
      "WHERE users.id = #{self.chef_id}"
    end

    topping_ids_query2 = <<~SQL.squish
    SELECT pizza_toppings.pizza_id, string_agg(pizza_toppings.topping_id::text, ', ' ORDER BY pizza_toppings.topping_id) AS topping_ids
    FROM pizzas
    LEFT OUTER JOIN pizza_toppings ON pizza_toppings.pizza_id = pizzas.id
    INNER JOIN users ON pizzas.chef_id = users.id
    #{where_clause}
    GROUP BY pizza_id;
    SQL

    results = self.class.connection.exec_query(topping_ids_query2)
    results.to_a.map { |row| row["topping_ids"] || "" } # => ["4, 5", "1, 3, 4, 5", ""]

  end

  def aggregate_own_topping_ids
    current_ids = self.pizza_toppings.map(&:topping_id)
    marked_ids = self.pizza_toppings.select(&:marked_for_destruction?).map(&:topping_id)
    projected_ids = current_ids - marked_ids
    # this may be called on a _new_ record, don't rely on .toppings or .topping_ids queries.
    projected_ids.sort.join(", ")
  end

  def unique_toppings
    if self.aggregate_own_topping_ids.in?(aggregate_sibling_pizza_topping_ids)
      self.errors.add(:base, "A pizza already exists with these toppings.")
    end
  end
end