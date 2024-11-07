class Pizza < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end