class PizzasController < ApplicationController
  before_action :authorize_current_user

  before_action :set_pizza, only: %i[ show edit update destroy ]
  before_action :set_toppings, only: [:new, :edit]

  # GET /pizzas or /pizzas.json
  # REFACTOR: This is currently handled by home#index
  def index
    # @pizzas = current_user.pizzas.all
    redirect_to root_path
  end

  # GET /pizzas/1 or /pizzas/1.json
  def show
  end

  # GET /pizzas/new
  def new
    @pizza = current_user.pizzas.new
  end

  # GET /pizzas/1/edit
  def edit
  end

  # POST /pizzas or /pizzas.json
  def create
    @pizza = current_user.pizzas.new(pizza_params)

    respond_to do |format|
      if @pizza.save
        format.html { redirect_to @pizza, notice: "Pizza was successfully created." }
        format.json { render :show, status: :created, location: @pizza }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pizza.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pizzas/1 or /pizzas/1.json
  def update
    respond_to do |format|
      if @pizza.update(pizza_params)
        format.html { redirect_to @pizza, notice: "Pizza was successfully updated." }
        format.json { render :show, status: :ok, location: @pizza }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pizza.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pizzas/1 or /pizzas/1.json
  def destroy
    @pizza.destroy!

    respond_to do |format|
      format.html { redirect_to pizzas_path, status: :see_other, notice: "Pizza was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pizza
      @pizza = current_user.pizzas.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pizza_params
      params.require(:pizza).permit(:name)
    end

    def set_toppings
      @toppings = current_user.manager.toppings.pluck(:name, :id)
    end

    def authorize_current_user
      SimpleAuthorization.role_auth(:chef, current_user)
    end
end
