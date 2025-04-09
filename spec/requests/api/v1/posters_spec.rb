require 'rails_helper'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe "Posters API", type: :request do
  before(:each) do
    @poster1 = Poster.create!(
      name: "DISASTER",
      description: "It's a mess",
      price: 43.00,
      year: 2016,
      vintage: false,
      img_url: "https://image1.jpg",
      created_at: 1.day.ago
    )
    
    @poster2 = Poster.create!(
      name: "TERRIBLE",
      description: "It's awful",
      price: 30.00,
      year: 2022,
      vintage: true,
      img_url: "https://image2.jpg",
      created_at: 2.days.ago
    )
    
    @poster3 = Poster.create!(
      name: "REGRET",
      description: "Bad choices",
      price: 100.00,
      year: 2020,
      vintage: true,
      img_url: "https://image3.jpg",
      created_at: 3.days.ago
    )
  end

  describe "GET /api/v1/posters" do
    it "returns all posters" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["data"].count).to eq(3)
      expect(parsed_response["meta"]["count"]).to eq(3)
    end
    
    it "formats the JSON response correctly" do
      get "/api/v1/posters"

      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body)
      poster_data = parsed_response["data"][0]

      expect(poster_data).to have_key("id")
      expect(poster_data).to have_key("type")
      expect(poster_data).to have_key("attributes")
      
      expect(poster_data["type"]).to eq("poster")
      expect(poster_data["attributes"]).to include("name", "description", "price", "year", "vintage", "img_url" )
    end
    
    it "filters posters by name" do
     get "/api/v1/posters?name=re"
      
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      
      


    end
    
    it "filters posters by minimum price" do
      get "/api/v1/posters?min_price=40"
      
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response["data"].count).to eq(2)

      min_price = parsed_response["data"].map { |poster| poster["attributes"]["price"]} 

      expect(min_price.all? { |price| price >= 40 }).to be true 
    end
    
    it "filters posters by maximum price" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
    end
    
    it "sorts posters by created_at in ascending order" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
    end
    
    it "sorts posters by created_at in descending order" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
    end
    
    it "combines filtering and sorting parameters" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
    end
    
    it "returns an empty array when no posters match the criteria" do
      get "/api/v1/posters"
      
      expect(response).to be_successful
    end
  end

  describe "GET /api/v1/posters/:id" do
    it "returns a single poster" do
      
    end
    
    it "returns a 404 when the poster doesn't exist" do
     
    end
  end
  
  describe "POST /api/v1/posters" do
    it "creates a new poster" do
      
    end
    
    it "ignores extra parameters" do
      
    end
  end
  
  describe "PATCH /api/v1/posters/:id" do
    it "updates a poster" do
      
    end
    
    it "returns a 404 when the poster doesn't exist" do
      
    end
  end
  
  describe "DELETE /api/v1/posters/:id" do
    before(:each) do
      @poster = Poster.create!(
        name: "DELETE",
        description: "please delete me...",
        price: 200.00,
        year: 2025,
        vintage: false,
        img_url: "https://delete.jpg"
      )
    end
    
    it "deletes a poster" do
      
    end
    
    it "returns a 404 when the poster doesn't exist" do
      
    end
  end
end