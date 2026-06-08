class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [ :edit, :update, :destroy ]

  def index
    @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
    @address = Address.new(full_name: [current_user.first_name, current_user.last_name].compact.join(" "))
  end

  def create
    @address = current_user.addresses.build(address_params)
    if @address.save
      redirect_to addresses_path, notice: "Адрес добавлен"
    else
      @addresses = current_user.addresses.order(is_default: :desc, created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Адрес обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "Адрес удалён"
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:full_name, :phone, :city, :street, :house, :apartment, :zip_code, :is_default)
  end
end
