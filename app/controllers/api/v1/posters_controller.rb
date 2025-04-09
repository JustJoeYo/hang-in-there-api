require_relative '../../../serializers/poster_serializer'

module Api
  module V1
    class PostersController < ApplicationController
      def index
        posters = sorted_posters
        render json: PosterSerializer.format_posters(posters)
      end

      def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.format_single_poster(poster)
      end

      def create
        poster = Poster.create(poster_params)
        render json: PosterSerializer.format_single_poster(poster)
      end

      def update
        poster = Poster.find_by(id: params[:id])
        poster.update(poster_params)
        render json: PosterSerializer.format_single_poster(poster)
      end
    
      def destroy
        poster = Poster.find(params[:id])
        poster.destroy
        head :no_content
      end

      private

      def poster_params
        params.permit(:name, :description, :price, :year, :vintage, :img_url)
      end

      def sorted_posters
        posters = Poster.all 

        if params[:name]
          search_name = "%#{params[:name].downcase}%"
          posters = posters.where("LOWER(name) LIKE ?", search_name).order(:name)
        end

        if params[:min_price]
          
        end

        if params[:max_price]
          
        end

        if params[:sort] && !params[:name]
          case params[:sort].downcase
          when "asc"
            posters = posters.order(created_at: :asc)
          when "desc"
            posters = posters.order(created_at: :desc)
          end
        end
      
        posters
      end
    end
  end
end