class OrderItemsController < ApplicationController
  before_action :set_current_order
  before_action :set_order_item, only: %i[update destroy]
  before_action :save_current_order, only: %i[create]

  def create
    @order_item = OrderItem.new(order_item_params)

    assign_order_to_user if current_user && @current_order.user_id.nil?
    #save_current_order if @current_order.id.nil?
    @order_item.order_id = @current_order.id
    @order_item.save

    redirect_back(fallback_location: root_path)
  end

  def update
    @order_item.update_attributes(order_item_params)
    @order_items = current_order.order_items

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @order_item.destroy

    redirect_back(fallback_location: root_path)
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id)
  end

  def set_order_item
    @order_item = current_order.order_items.find(params[:id])
  end

  def set_current_order
    @current_order = current_order
  end

  def save_current_order
    @current_order.save
    session[:order_id] = @current_order.id
  end

  def assign_order_to_user
    @current_order.update_attributes(user_id: current_user.id)
  end
end
