class CartsController < ApplicationController
  def add
    current_cart.add_item(params[:id])
    session[Cart::SessionKey] = current_cart.serialize

    flash[:success] = "已加入購物車"
    redirect_to(request.env['HTTP_REFERER']) # redirect back
  end

  def show
    @client_token = Braintree::ClientToken.generate
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

  def checkout
    nonce = params[:payment_method_nonce]

    result = Braintree::Transaction.sale(
      amount: current_cart.total_price ,
      payment_method_nonce: nonce,
    )
    if result
      session[Cart::SessionKey] = nil
      flash[:notice] = "已清空您的購物車"
      flash[:success] = "刷卡成功"
      redirect_to products_path
    else
      flash[:error] = "請確認卡號與日期"
      redirect_to cart_path
    end
  end
end
