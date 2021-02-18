# frozen_string_literal: true

# products controller
class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :fetch_product, except: %i[index new create my_products]
  before_action :valid_product_owner!, only: %i[update destroy publish archive]

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

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_url, notice: 'Product was successfully saved.' }
        format.json { head :no_content }
      else
        format.html { render :new, alert: 'You have to complete all of inputs.' }
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
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @products.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    @product.archived!
  end

  def publish
    @product.published!

    send_email(@product)
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
                                    images_attributes: %i[id image _destroy])
  end

  def fetch_product
    @product = Product.find(params[:id])
  end
end
