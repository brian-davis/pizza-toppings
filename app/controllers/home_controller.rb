class HomeController < ApplicationController
  before_action :set_dashboard, only: :index
  before_action :set_dashboard_items, only: :index

  def index
  end

  private

  def set_dashboard
    @dashboard_template = "#{current_user.role}_dashboard" # partial template
  end

  def set_dashboard_items
    @dashboard_items = case current_user.role
    when "owner"
      current_user.toppings.all
    when "chef"
      current_user.pizzas.all
    end
  end
end
