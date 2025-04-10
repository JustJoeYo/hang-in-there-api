class Poster < ApplicationRecord
  def self.filter_and_sort(params)
    posters = Poster.all 

    if params[:name]
      search_name = "%#{params[:name].downcase}%"
      posters = posters.where("LOWER(name) LIKE ?", search_name).order(:name)
    end

    if params[:min_price]
      posters = posters.where("price >= ?", params[:min_price])
    end

    if params[:max_price]
      posters = posters.where("price <= ?", params[:max_price])
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