# README

[requirements](https://github.com/StrongMind/culture/blob/main/recruit/full-stack-developer.md)

## Setup

This is application has been built with Ruby 3.3 and Rails 7.2.2.  It is configured to use a PostgreSQL database.  To run locally, you must have those items (and the Bundler gem) installed and running, and you should be able to run `gem install pg`, which is sensitive to your Postgres installation.  Clone the repo, cd into `pizza-toppings`, and run `bundle install`, then `rails db:create db:migrate db:seed`. Then run a local server with `rails server`.  Run tests with `rails test`.

The [Devise gem](https://github.com/heartcombo/devise) is used for authentication.  Because this is a demo app and will be deployed temporarily, and without using a mailer in production, the registration and recovery modules have been disabled.  You will not be able to create users (except in the rails console in development mode).  You will be able to test the user roles as owner or chef using the pre-made users defined in db/seeds.rb:

chef1@example.com/chef1_password

owner1@example.com/owner1_password