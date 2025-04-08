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
        # render json: format_poster(posters)
      end

      def show
        poster = Poster.find(params[:id])
        render json: format_poster(poster)
      end

      def create
        render json: Poster.create(poster_params)
      end

      def update
        poster = Poster.find_by(id: params[:id])
  
        poster.update(poster_params)
          render json: {
            data: format_poster(poster)
        }
      end
    
      def destroy
        render json: Poster.delete(params[:id])
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



