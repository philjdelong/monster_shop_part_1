class OrdersController <ApplicationController
  before_action :format_params

  def new
  end

  def index
    @user = current_user
    @orders = @user.orders
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    user = User.find(params[:id])
    order = user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = 'Order ho! Ye successfully placed yer order. Make way in yer hold for loot!'
      redirect_to "/profile/orders"
    else
      flash[:error] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(update_params)
    if order.save
      if order.cancelled?
        flash[:success] = "Your Order has been Cancelled"
        redirect_to "/profile"
      elsif current_user.admin?
        redirect_to "/admin"
      end
    end
  end

  private

  def format_params
    params[:status] = params[:status].to_i
  end

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def update_params
    params.permit(:status)
  end
end
