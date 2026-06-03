class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @orders = @user.orders.includes(:order_items).order(created_at: :desc).limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if password_params_present?
      if @user.update_with_password(profile_params)
        bypass_sign_in(@user)
        redirect_to profile_path, notice: "Профиль обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(profile_params.except(:current_password, :password, :password_confirmation))
        redirect_to profile_path, notice: "Профиль обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def password_params_present?
    params[:user][:password].present? || params[:user][:password_confirmation].present?
  end

  def profile_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone, :current_password, :password, :password_confirmation)
  end
end
