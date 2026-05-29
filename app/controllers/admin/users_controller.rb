class Admin::UsersController < Admin::BaseController
  before_action :require_admin, only: [ :edit, :update ]

  def index
    scope = User.order(created_at: :desc)
    scope = scope.where(role: params[:role]) if params[:role].present?
    @pagy, @users = pagy(scope, items: 20)
  end

  def show
    @user = User.includes(:orders, :reviews).find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "Пользователь обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to admin_users_path, alert: "Только администратор может изменять роли"
    end
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
