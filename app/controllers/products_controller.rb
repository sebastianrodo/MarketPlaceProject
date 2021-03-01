class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :fetch_product, only: [:edit, :show, :destroy, :update, :archive]

  def index
    @products = Product.all.paginate(page: params[:page], per_page: 3).published
    @img = Image.all
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

  def show
    @images = Image.where(product_id: params[:id])
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  def update
    if valid_user!
      @product.update(product_params)

      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to products_url,
                      notice: 'It was not updated, you are not the owner of this product.' }
      end
    end
  end

  def archive
    @product.archived!
  end

  private

  def product_params
    params.require(:product).permit(:name,
                                    :description,
                                    :quantity,
                                    :price,
                                    :category,
                                    images_attributes: [:id, :image, :_destroy])
  end

  def fetch_product
    @product = Product.find(params[:id])
  end
end
