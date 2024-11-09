# README

[requirements](https://github.com/StrongMind/culture/blob/main/recruit/full-stack-developer.md)

## Setup

This is application has been built with Ruby 3.3 and Rails 7.2.2.  It is configured to use a PostgreSQL database.  To run locally, you must have those items (and the Bundler gem) installed and running, and you should be able to run `gem install pg`, which is sensitive to your Postgres installation.  Clone the repo, cd into `pizza-toppings`, and run `bundle install`, then `rails db:create db:migrate db:seed`. Then run a local server with `rails server`.  Run tests with `rails test`.

The deployed production app is available [here](https://sleepy-lake-10238-75aee12a7274.herokuapp.com/).

Some development technical choices and details:

* For User authentication I used the standard Devise gem for convenience, and for authorization, I rolled my own simple service object [here](https://github.com/brian-davis/pizza-toppings/blob/main/app/services/simple_authorization.rb).  This is based on a simple `enum` column on the User model.  That seemed sufficient for the very limited requirements, with no need to bring in another gem such as CanCan or Pundit.  Because this is a demo app and will be deployed temporarily, and without using a mailer in production, the registration and recovery modules have been disabled.  You will not be able to create users (except in the rails console in development mode).  You will be able to test the user roles as owner or chef using the pre-made users defined in db/seeds.rb:

email:`chef1@example.com`
password:`chef1_password`

email:`owner1@example.com`
password:`owner1_password`

email:`chef2@example.com`
password:`chef2_password`

email:`owner2@example.com`
password:`owner2_password`

* I used a Rails 7 Stimulus/Turbo controller [here](https://github.com/brian-davis/pizza-toppings/blob/main/app/javascript/controllers/pizzas_controller.js) for managing the pizza form.  I followed a pattern I had previously developed on a personal project, in which nested form elements for associated objects (toppings belonging to the pizza) can be added and removed dynamically.  I enjoy using the new Hotwire architecture included in Rails 7, with front-end StimulusJS controller code, and using Turbo for responses with html templating rendered on the back-end.  Using these tools, I am able to build out input elements with `name` attributes that conform to the Rails form builder conventions and which structure a parameters object correctly for the back-end controller.

* Validation of duplicate pizzas was tricky, as I interpret two pizzas having the same list of associated toppings as being duplicate.  I wrote a custom validation method [here](https://github.com/brian-davis/pizza-toppings/blob/main/app/models/pizza.rb#L63) which runs an aggregation query across the join table to determine what the toppings on the existing pizzas are.  It was complicated by the fact that the validation on the pizza object runs before any of the associations have been removed on update (if this was specified by the form parameters), and this required special [logic](https://github.com/brian-davis/pizza-toppings/blob/main/app/models/pizza.rb#L55) for handling this [edge case](https://github.com/brian-davis/pizza-toppings/blob/main/test/models/pizza_test.rb#L105).  Additionally, I found that validations actually run multiple times during the create cycle, once before the object has been persisted, and has an `id`, and once after, and custom SQL needed to accomodate that.

* Front-end styling is done in simple CSS, and does not rely on any framework like Bootstrap.  I use some `flexbox` logic.  All templating is simple Ruby ERB, without any other templating engine such as HAML or SLIM.

* Deployment is to a simple Heroku eco dyno.  Heroku is what I am most familiar with and is most convenient for me.