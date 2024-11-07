class Pizza < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :chef_id }
  validate :chef_role

  belongs_to :chef, class_name: "User", foreign_key: :chef_id

  private

  def chef_role
    if self.chef && !self.chef.role_chef?
      self.errors.add(:base, "Associated User must have chef role")
    end
  end
end