module Users
  class ProductsController < ApplicationController
    def index
      @products = current_user.products.paginate(page: params[:page], per_page: 3)
      @img = Image.all
    end
  end
end
