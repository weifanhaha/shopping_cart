class CartsController < ApplicationController
  def add
    current_cart.add_item(params[:id])
    session[:cart007] = current_cart.serialize

    flash[:success] = "已加入購物車"
    redirect_to products_path
  end
end
