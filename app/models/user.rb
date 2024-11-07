class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable # :registerable, :recoverable,

  # TODO: user hierarchy relation (self-join)
  enum :role, [:owner, :chef], prefix: true
end
