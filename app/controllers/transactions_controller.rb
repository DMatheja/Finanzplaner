class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions.includes(:product).order(transaction_date: :desc)
  end
  
  def new
    @product = Product.find(params[:product_id])
    @transaction = @product.transactions.build
  end
  
  def create
    @transaction = current_user.transactions.build(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: 'Purchase recorded successfully'
    else
      @product = @transaction.product
      render :new
    end
  end
  
  private
  
  def transaction_params
    params.require(:transaction).permit(:product_id, :amount, :transaction_date)
  end
end
