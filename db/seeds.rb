User.delete_all
Topping.delete_all
Pizza.delete_all

chef1 = User.create({
  email: "chef1@example.com",
  password: "chef1_password",
  password_confirmation: "chef1_password",
  role: :chef
})

owner1 = User.create({
  email: "owner1@example.com",
  password: "owner1_password",
  password_confirmation: "owner1_password",
  role: :owner
})

chef2 = User.create({
  email: "chef2@example.com",
  password: "chef2_password",
  password_confirmation: "chef2_password",
  role: :chef
})

owner2 = User.create({
  email: "owner2@example.com",
  password: "owner2_password",
  password_confirmation: "owner2_password",
  role: :owner
})
binding.irb
Topping.find_or_create_by({
  name: "Pepperoni",
  owner: owner1
})

Topping.find_or_create_by({
  name: "Sausage",
  owner: owner2
})

Topping.find_or_create_by({
  name: "Olives",
  owner: owner1
})

Pizza.find_or_create_by({
  name: "Margherita",
  chef: chef1
})

Pizza.find_or_create_by({
  name: "Napoletana",
  chef: chef2
})