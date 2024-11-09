class Topping < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :owner_id }
  validate :owner_role

  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :pizza_toppings, dependent: :destroy
  has_many :pizzas, through: :pizza_toppings

  def pizza_list
    pizzas.pluck(:name).sort.to_sentence
  end

  private

  def owner_role
    if self.owner && !self.owner.role_owner?
      self.errors.add(:base, "Associated User must have owner role")
    end
  end
end
