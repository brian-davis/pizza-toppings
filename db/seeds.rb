# User.delete_all

User.create({
  email: "chef1@example.com",
  password: "chef1_password",
  password_confirmation: "chef1_password",
  role: :chef
}) # fail without raising exception on 2nd run

User.create({
  email: "owner1@example.com",
  password: "owner1_password",
  password_confirmation: "owner1_password",
  role: :owner
}) # fail without raising exception on 2nd run

Topping.find_or_create_by({
  name: "Pepperoni"
})

Topping.find_or_create_by({
  name: "Sausage"
})

Topping.find_or_create_by({
  name: "Olives"
})