module Users
  module Products
    class ArchivesController < ApplicationController
      def update
        @product = Product.find(params[:product_id])
        @product.archive!
      end
    end
  end
end
