class Admin::PromoCodesController < Admin::BaseController
  def index
    @pagy, @promo_codes = pagy(PromoCode.order(created_at: :desc), items: 20)
  end

  def new
    @promo_code = PromoCode.new
  end

  def create
    @promo_code = PromoCode.new(promo_code_params)
    if @promo_code.save
      redirect_to admin_promo_codes_path, notice: "Промокод создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @promo_code = PromoCode.find(params[:id])
  end

  def update
    @promo_code = PromoCode.find(params[:id])
    if @promo_code.update(promo_code_params)
      redirect_to admin_promo_codes_path, notice: "Промокод обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @promo_code = PromoCode.find(params[:id])
    @promo_code.destroy
    redirect_to admin_promo_codes_path, notice: "Промокод удалён"
  end

  private

  def promo_code_params
    params.require(:promo_code).permit(:code, :discount, :active, :expires_at, :max_uses)
  end
end