class PosterSerializer
  def self.format_poster(poster)
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
  
  def self.format_posters(posters)
    {
      data: posters.map { |poster| format_poster(poster) },
      meta: { count: posters.length }
    }
  end
  
  def self.format_single_poster(poster)
    {
      data: format_poster(poster)
    }
  end

  

end