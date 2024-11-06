# README

[requirements](https://github.com/StrongMind/culture/blob/main/recruit/full-stack-developer.md)

## Setup

This is application has been built with Ruby 3.3 and Rails 7.2.2.  It is configured to use a PostgreSQL database.  To run locally, you must have those items (and the Bundler gem) installed and running, and you should be able to run `gem install pg`, which is sensitive to your Postgres installation.  Clone the repo, cd into `pizza-toppings`, and run `bundle install`, then `rails db:create db:migrate db:seed`. Then run a local server with `rails server`.  Run tests with `rails test`.