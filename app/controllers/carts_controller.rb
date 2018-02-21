class CartsController < ApplicationController
  def add
    current_cart.add_item(params[:id])
    session[Cart::SessionKey] = current_cart.serialize

    flash[:success] = "已加入購物車"
    redirect_to(request.env['HTTP_REFERER']) # redirect back
  end

  def show
  end

  def remove
    current_cart.delete_item(params[:id])
    session[Cart::SessionKey] = current_cart.serialize

    flash[:success] = "已從購物車移除"
    redirect_back(fallback_location: cart_path)
  end

  def destroy
    session[Cart::SessionKey] = nil
    flash[:success] = "已清空購物車"
    redirect_to products_path
  end
end
