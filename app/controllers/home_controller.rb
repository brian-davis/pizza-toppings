class HomeController < ApplicationController
  before_action :set_dashboard, only: :index

  def index
  end

  private

  def set_dashboard
    @dashboard_template = "#{current_user.role}_dashboard" # partial template
  end
end
