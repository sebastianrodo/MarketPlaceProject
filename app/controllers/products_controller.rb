class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :fetch_product, except: [:index, :new, :create, :my_products]

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
    if @product.save
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully saved.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'You have to complete all of inputs.'
        format.html { render :new}
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
      if valid_product_owner! || current_user.admin_role?
        if @product.update(product_params)
          format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
        else
          format.html { render :edit }
        end
      else
        flash.now[:alert] = 'It was not updated, you are not the owner of this product.'
      end
    end
  end

  def archive
    respond_to do |format|
      if valid_product_owner! || current_user.admin_role?
        @product.archived!
          format.html { redirect_to products_url, notice: 'Product was successfully archived.' }
        end
      else
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

  def fetch_product
    @product = Product.find(params[:id])
  end
end
