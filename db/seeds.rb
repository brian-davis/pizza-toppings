User.delete_all

User.create({
  email: "chef1@example.com",
  password: "chef1_password",
  password_confirmation: "chef1_password",
  role: :chef
})

User.create({
  email: "owner1@example.com",
  password: "owner1_password",
  password_confirmation: "owner1_password",
  role: :owner
})