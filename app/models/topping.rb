class Topping < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
