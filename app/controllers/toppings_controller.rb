class ToppingsController < ApplicationController
  before_action :authorize_current_user

  before_action :set_topping, only: %i[ show edit update destroy ]

  # GET /toppings or /toppings.json
  # REFACTOR: This is currently handled by home#index
  def index
    # @toppings = current_user.toppings.all
    redirect_to root_path
  end

  # GET /toppings/1 or /toppings/1.json
  def show
  end

  # GET /toppings/new
  def new
    @topping = current_user.toppings.new
  end

  # GET /toppings/1/edit
  def edit
  end

  # POST /toppings or /toppings.json
  def create
    @topping = current_user.toppings.new(topping_params)

    respond_to do |format|
      if @topping.save
        format.html { redirect_to @topping, notice: "Topping was successfully created." }
        format.json { render :show, status: :created, location: @topping }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @topping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /toppings/1 or /toppings/1.json
  def update
    respond_to do |format|
      if @topping.update(topping_params)
        format.html { redirect_to @topping, notice: "Topping was successfully updated." }
        format.json { render :show, status: :ok, location: @topping }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @topping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /toppings/1 or /toppings/1.json
  def destroy
    @topping.destroy!

    respond_to do |format|
      format.html { redirect_to toppings_path, status: :see_other, notice: "Topping was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topping
      @topping = current_user.toppings.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def topping_params
      params.require(:topping).permit(:name)
    end

    def authorize_current_user
      SimpleAuthorization.role_auth(:owner, current_user)
    end
end
