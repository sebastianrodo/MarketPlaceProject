class ProductsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_product, only: [:update]

  def index
    @products = Product.all.paginate(page: params[:page], per_page: 3)
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = current_user.products.new(product_params)
    @product.category_id = params[:category]
    if @product.save
      flash[:success] = "Product successfully created"
      redirect_to products_url
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_url
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_url
    else
      redirect_to products_url
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :quantity, :price, :category)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
