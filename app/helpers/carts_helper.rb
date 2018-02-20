module CartsHelper
  def current_cart
    @cart ||= Cart.from_hash(session[:cart007])
  end
end
