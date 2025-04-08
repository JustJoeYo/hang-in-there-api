module Api
  module V1
    class PostersController < ApplicationController
      require_relative '../../../serializers/poster_serializer'
      def index
        posters = Poster.all
        render json: ::PosterSerializer.format_posters(posters)
      end

      def show
        poster = Poster.find(params[:id])
        render json: ::PosterSerializer.format_single_poster(poster)
      end

      def create
        poster = Poster.create(poster_params)
        render json: ::PosterSerializer.format_single_poster(poster)
      end

      def update
        poster = Poster.find_by(id: params[:id])
        poster.update(poster_params)
        render json: ::PosterSerializer.format_single_poster(poster)
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
    end
  end
end