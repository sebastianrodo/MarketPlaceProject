class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_product, except: [:index, :new, :create]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit; end

  def create
    @product = current_user.products.new(product_params)
    @product.category_id = params[:category]
    if @product.save
      flash[:success] = "Product successfully created"
      redirect_to products_url
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  def update
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

  def fetch_product
    @product = Product.find(params[:id])
  end
end
