class PizzasTurboController < ApplicationController
  before_action :authorize_current_user

  def select_topping
    @pizza = current_user.pizzas.find(params[:pizza_id]) if params[:pizza_id]
    @pizza ||= current_user.pizzas.new
    @topping = current_user.chef_toppings.find(params[:topping_id])
  end

  private

    def authorize_current_user
      SimpleAuthorization.role_auth(:chef, current_user)
    end
end
