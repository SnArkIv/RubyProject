class Admin::BaseController < ApplicationController
  include Pagy::Backend

  layout "admin"

  before_action :authenticate_user!
  before_action :require_admin_or_manager

  private

  def require_admin_or_manager
    unless current_user&.admin_or_manager?
      redirect_to root_path, alert: "Доступ запрещён"
    end
  end
end
