class EmployeesController < ApplicationController
  before_action :authorize_current_user

  def index
    @employees = current_user.employees.order(:name)
  end

  def show
    @employee = current_user.employees.find(params[:id])
  end

  private

  def authorize_current_user
    SimpleAuthorization.role_auth(:owner, current_user)
  end
end