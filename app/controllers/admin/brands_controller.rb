class Admin::BrandsController < Admin::BaseController
  def index
    @brands = Brand.order(:name)
    if params[:q].present?
      @brands = @brands.where("name ILIKE ?", "%#{params[:q]}%")
    end
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to admin_brands_path, notice: "Бренд создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update(brand_params)
      redirect_to admin_brands_path, notice: "Бренд обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    if @brand.products.exists?
      redirect_to admin_brands_path, alert: "Нельзя удалить бренд, у которого есть товары"
    else
      @brand.destroy
      redirect_to admin_brands_path, notice: "Бренд удалён"
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end
