module Users
  module Products
    class PublishesController < ApplicationController
      def update
        @product = Product.find(params[:product_id])
        @product.publish!
      end
    end
  end
end
