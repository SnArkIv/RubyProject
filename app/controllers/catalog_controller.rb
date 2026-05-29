class CatalogController < ApplicationController
  include Pagy::Backend

  def index
    @query = query_params
    scope = Product.published.includes(:category, :brand, images_attachments: :blob)
    scope = scope.search(@query[:q])
    scope = scope.by_category(@query[:category_id])
    scope = scope.by_brand(@query[:brand_id])
    scope = scope.by_gender(@query[:gender])
    scope = scope.by_sizes(@query[:sizes])
    scope = scope.by_colors(@query[:colors])
    scope = scope.price_min(@query[:price_min])
    scope = scope.price_max(@query[:price_max])
    scope = scope.in_stock if @query[:in_stock].present?

    scope = case @query[:sort]
    when "price_asc"
      scope.price_asc
    when "price_desc"
      scope.price_desc
    when "popularity"
      scope.by_popularity
    when "newest"
      scope.newest
    when "discount"
      scope.discount_desc
    else
      scope.newest
    end

    @pagy, @products = pagy(scope, items: 12)
    @categories = Category.order(:name)
    @brands = Brand.order(:name)
    @colors = Product.where.not(color: [ nil, "" ]).distinct.pluck(:color).sort
    @sizes = Product.where("sizes <> '{}'").distinct.pluck(:sizes).flatten.uniq.sort
  end

  private

  def query_params
    params.permit(
      :q, :category_id, :brand_id, :gender, :price_min, :price_max,
      :sort, :in_stock, sizes: [], colors: []
    ).to_h.symbolize_keys
  end
end
