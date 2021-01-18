class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  respond_to :html, :json, :js
  before_action :set_product, except: [:index, :new, :create, :my_products]

  def index
    @products = Product.all.paginate(page: params[:page], per_page: 3).published
    @img = Image.all
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully saved.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'You have to complete all of inputs.'
        format.html { render :new}
        format.json { render json: @products.errors, status: :unprocessable_entity }
      end
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
    if valid_product_owner!
      if @product.update(product_params)
        respond_to do |format|
          format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @products.errors, status: :unprocessable_entity }
        end
      end
    else
      flash.now[:alert] = 'It was not updated, you are not the owner of this product.'
    end
  end

  def archive
    if valid_product_owner!
      @product.archived!
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully archived.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to products_url,
                      alert: 'It was not deleted, you are not the owner of this product.' }
      end
    end
  end

  def publish
    if valid_product_owner!
      @product.published!
      User.find_each do |user|
        NotifierMailer.email(user, @product).deliver_later
      end
      respond_to do |format|
        format.html { redirect_to my_products_url, notice: 'Product was successfully published.' }
        format.json { head :no_content }
      end
    end
  end

  def my_products
    @products = current_user.products.paginate(page: params[:page], per_page: 3)
    @img = Image.all
  end

  private

  def product_params
    params.require(:product).permit(:name,
                                    :description,
                                    :quantity,
                                    :price,
                                    :category_id,
                                    images_attributes: [:id, :image, :_destroy])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
