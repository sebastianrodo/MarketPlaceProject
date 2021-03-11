module Users
  class ProductsController < ApplicationController
    def index
      @products = current_user.products.includes(:images).paginate(page: params[:page], per_page: 3)
    end
  end
end
