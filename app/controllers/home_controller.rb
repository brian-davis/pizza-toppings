class HomeController < ApplicationController
  before_action :set_dashboard, only: :index

  def index
    render @dashboard_template
  end

  private

  def set_dashboard
    @dashboard_template = "#{current_user.role}_dashboard"
  end
end
