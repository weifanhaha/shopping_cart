class ProductsController < ApplicationController
  before_action :find_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all
  end

  # def show
  # end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create product_params
    flash[:success] = "新增成功"
    redirect_to products_path
  rescue StandardError => e
    flash[:error] = "發生錯誤 : #{e}"
    redirect_to new_product_path
  end

  # def edit
  # end

  def update
    @product.update_attributes!(product_params)
    flash[:success] = "更新成功"
    redirect_to products_path
  rescue StandardError => e
    flash[:error] = "發生錯誤 : #{e}"
    redirect_to edit_product_path
  end

  def destroy
    @product.destroy!
    flash[:success] = "商品已刪除"
    redirect_to products_path
  end

  private
  def find_product
    @product = Product.find(params[:id])
    redirect_to products_path, notice: "無此商品" unless @product
  end

  def product_params
    # params.require(:product).permit(:title, :description, :price)
    params.require(:product).permit!
  end
end
