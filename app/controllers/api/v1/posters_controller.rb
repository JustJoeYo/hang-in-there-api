require_relative '../../../serializers/poster_serializer'

module Api
  module V1
    class PostersController < ApplicationController
      def index
        posters = Poster.filter_and_sort(params)
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
        
        if poster
          poster.update(poster_params)
          render json: PosterSerializer.format_single_poster(poster)
        else
          render json: { error: "Poster not found" }, status: :not_found # 404 Not Found edge case, could add to all but update is most important (for my test right now)
        end
      end
    
      def destroy
        poster = Poster.find(params[:id])
        poster.destroy
        head :no_content
      end

      private

      def poster_params # this is context specific, should i really move it to the model?
        params.permit(:name, :description, :price, :year, :vintage, :img_url)
      end
    end
  end
end