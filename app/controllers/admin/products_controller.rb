class Admin::ProductsController < Admin::BaseController
  def index
    scope = Product.includes(:category, :brand, images_attachments: :blob)
    scope = scope.search(params[:q]) if params[:q].present?
    scope = scope.where(status: params[:status]) if params[:status].present?
    @pagy, @products = pagy(scope.order(created_at: :desc), items: 20)
  end

  def new
    @product = Product.new
    @categories = Category.order(:name)
    @brands = Brand.order(:name)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      attach_images
      redirect_to admin_products_path, notice: "Товар создан"
    else
      @categories = Category.order(:name)
      @brands = Brand.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.order(:name)
    @brands = Brand.order(:name)
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      attach_images
      redirect_to admin_products_path, notice: "Товар обновлён"
    else
      @categories = Category.order(:name)
      @brands = Brand.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path, notice: "Товар удалён"
  end

  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :discount, :sku, :status, :in_stock,
      :category_id, :brand_id, :gender, :material, :color, :care_instructions,
      sizes: [], images: []
    )
  end

  def attach_images
    if params[:product][:images].present?
      params[:product][:images].each do |img|
        @product.images.attach(img)
      end
    end
  end
end
