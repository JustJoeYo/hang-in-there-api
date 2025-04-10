class Poster < ApplicationRecord
  def self.filter_and_sort(params)
    posters = Poster.all
    
    posters = filter_by_name(posters, params[:name]) if params[:name]
    posters = filter_by_min_price(posters, params[:min_price]) if params[:min_price]
    posters = filter_by_max_price(posters, params[:max_price]) if params[:max_price]
    posters = sort_posters(posters, params[:sort], params[:name]) if params[:sort]
    
    posters
  end
  
  def self.filter_by_name(posters, name)
    search_name = "%#{name.downcase}%"
    posters.where("LOWER(name) LIKE ?", search_name).order(:name)
  end
  
  def self.filter_by_min_price(posters, min_price)
    posters.where("price >= ?", min_price)
  end
  
  def self.filter_by_max_price(posters, max_price)
    posters.where("price <= ?", max_price)
  end

  def self.sort_posters(posters, sort_param, name_param)
    return posters if name_param
    
    case sort_param.downcase
    when "asc"
      posters.order(created_at: :asc)
    when "desc"
      posters.order(created_at: :desc)
    else
      posters
    end
  end
end