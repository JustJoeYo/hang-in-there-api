module Api
  module V1
    class PostersController < ApplicationController
      def index
        posters = Poster.all
        
        render json: {
          data: posters.map do |poster|
            format_poster(poster)
          end
        }
      end

      def show
        
      end

      def create
       
      end

      def update
        
      end

      def destroy
        
      end
    end
  end
end