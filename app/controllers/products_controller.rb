class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :checkout]

  def index
    @products = Product.all
  end

  def show
    @client_token = Braintree::ClientToken.generate
  end

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

  def edit
  end

  def update
    @product.update_attributes!(product_params)
    flash[:success] = "更新成功"
    redirect_to products_path
  rescue StandardError => e
    flash[:error] = "發生錯誤 : #{e}"
    redirect_to edit_product_path
  end

  def destroy
    current_cart.delete_item(@product.id.to_s)
    session[Cart::SessionKey] = current_cart.serialize
    @product.destroy!
    flash[:success] = "商品已刪除"
    redirect_to products_path
  end

  def checkout
    nonce = params[:payment_method_nonce]

    result = Braintree::Transaction.sale(
      amount: @product.price ,
      payment_method_nonce: nonce,
    )
    if result
      flash[:success] = "刷卡成功"
      redirect_to products_path
    else
      flash[:error] = "請確認卡號與日期"
      redirect_to checkout_product_path
    end
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
