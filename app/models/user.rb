class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable # :registerable, :recoverable,

  has_many :employees, class_name: "User", foreign_key: :manager_id
  belongs_to :manager, class_name: "User", foreign_key: :manager_id, optional: true

  # REFACTOR: single-table inheritance may be better here:
  # https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
  enum :role, [:owner, :chef], prefix: true

  has_many :pizzas, inverse_of: :chef, foreign_key: :chef_id, dependent: :destroy
  has_many :toppings, inverse_of: :owner, foreign_key: :owner_id, dependent: :destroy

  def chef_toppings
    return unless role_chef?
    manager.toppings
  end
end
