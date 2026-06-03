class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.order(:name)
    if params[:q].present?
      @categories = @categories.where("name ILIKE ?", "%#{params[:q]}%")
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Категория создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Категория обновлена"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.products.exists?
      redirect_to admin_categories_path, alert: "Нельзя удалить категорию, в которой есть товары"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Категория удалена"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
