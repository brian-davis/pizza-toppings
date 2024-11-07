class PizzaTopping < ApplicationRecord
  belongs_to :pizza
  belongs_to :topping
  validates :pizza_id, uniqueness: { scope: :topping_id }

  validate :topping_avialable

  private

  def topping_avialable
    if (pizza && topping) && topping.owner != pizza.chef&.manager
      errors.add(:base, "Topping not available")
    end
  end
end
