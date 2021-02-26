class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product successfully created"
      redirect_to products_url
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :quantity, :price)
  end

end
