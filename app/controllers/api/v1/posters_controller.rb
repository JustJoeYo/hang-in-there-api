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

      private 

      def poster_params
        params.permit(:name, :description, :price, :year, :vintage, :img_url)
      end

      def format_poster(poster)
        {
          id: poster.id.to_s,
          type: 'poster',
          attributes: {
            name: poster.name,
            description: poster.description,
            price: poster.price,
            year: poster.year,
            vintage: poster.vintage,
            img_url: poster.img_url
          }
        }
      end
    end
  end
end