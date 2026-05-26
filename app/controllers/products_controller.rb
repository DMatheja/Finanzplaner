class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = current_user.categories
    @products = Product.joins(:category).where(categories: { user_id: current_user.id })
  end
  
  def show
  end
  
  def new
    @product = Product.new
    @categories = current_user.categories
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product created successfully'
    else
      @categories = current_user.categories
      render :new
    end
  end
  
  def edit
    @categories = current_user.categories
  end
  
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product updated successfully'
    else
      @categories = current_user.categories
      render :edit
    end
  end
  
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product deleted successfully'
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def product_params
    params.require(:product).permit(:category_id, :name, :price)
  end
end
