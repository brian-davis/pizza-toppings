owner1 = User.create({
  email: "owner1@example.com",
  password: "owner1_password",
  password_confirmation: "owner1_password",
  role: :owner
})

chef1 = User.create({
  email: "chef1@example.com",
  password: "chef1_password",
  password_confirmation: "chef1_password",
  role: :chef,
  manager: owner1
})


owner2 = User.create({
  email: "owner2@example.com",
  password: "owner2_password",
  password_confirmation: "owner2_password",
  role: :owner
})

chef2 = User.create({
  email: "chef2@example.com",
  password: "chef2_password",
  password_confirmation: "chef2_password",
  role: :chef,
  manager: owner2
})

topping1 = Topping.create({
  name: "Pepperoni",
  owner: owner1
})

topping2 = Topping.create({
  name: "Sausage",
  owner: owner2
})

topping3 = Topping.create({
  name: "Olives",
  owner: owner1
})

topping4 = Topping.create({
  name: "Tomato",
  owner: owner1
})

topping5 = Topping.create({
  name: "Basil",
  owner: owner1
})

topping6 = Topping.create({
  name: "Napoletana Cheese",
  owner: owner2
})

pizza1 = Pizza.create({
  name: "Margherita",
  chef: chef1
})

pizza1.toppings << topping4
pizza1.toppings << topping5

pizza2 = Pizza.create({
  name: "Napoletana",
  chef: chef2,
})

pizza2.toppings << topping6