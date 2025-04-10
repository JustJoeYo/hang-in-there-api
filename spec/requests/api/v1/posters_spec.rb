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
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data].count).to eq(3)
      expect(parsed_response[:meta][:count]).to eq(3)
    end
    
    it "formatted JSON response" do
      get "/api/v1/posters"

      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      poster_data = parsed_response[:data][0]

      expect(poster_data).to have_key(:id)
      expect(poster_data).to have_key(:type)
      expect(poster_data).to have_key(:attributes)
      
      expect(poster_data[:type]).to eq("poster")
      expect(poster_data[:attributes]).to include(:name, :description, :price, :year, :vintage, :img_url)
    end
    
    it "filters posters by name" do
     get "/api/v1/posters?name=re"
      
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      names = parsed_response[:data].map { |poster| poster[:attributes][:name]}

      expect(names).to include("REGRET")
      expect(names).not_to include("DISASTER", "TERRIBLE")
    end
    
    it "filters posters by min_price" do
      get "/api/v1/posters?min_price=40"
      
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data].count).to eq(2)

      min_price = parsed_response[:data].map { |poster| poster[:attributes][:price]} 

      expect(min_price.all? { |price| price >= 40 }).to be true 
    end
    
    it "filters posters by max_price" do
      get "/api/v1/posters?max_price=40"
      
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data].count).to eq(1)

      min_price = parsed_response[:data].map { |poster| poster[:attributes][:price]} 

      expect(min_price.all? { |price| price <= 40 }).to be true 
    end
    
    it "sorts posters by created_at in asc order" do
      get "/api/v1/posters?sort=asc"
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      poster_ids = parsed_response[:data].map {|poster| poster[:id].to_i}

      expect(poster_ids.first).to eq(@poster3.id)
      expect(poster_ids.last).to eq(@poster1.id)
    end
    
    it "sorts posters by created_at in desc order" do
      get "/api/v1/posters?sort=desc" 
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      poster_ids = parsed_response[:data].map {|poster| poster[:id].to_i}

      expect(poster_ids.first).to eq(@poster1.id)
      expect(poster_ids.last).to eq(@poster3.id)
      
    end
    
    it "filtering and sorting parameters one query" do
      get "/api/v1/posters?min_price=40&max_price=120&sort=desc"
      expect(response).to be_successful

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response[:data].count).to eq(2)
      
      poster_ids = parsed_response[:data].map {|poster| poster[:id].to_i}
      expect(poster_ids.first).to eq(@poster1.id)
      expect(poster_ids.last).to eq(@poster3.id)
    end
    
    it "no posters match the criteria case" do
      get "/api/v1/posters?min_price=1000"
      
      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data]).to be_empty
      expect(parsed_response[:meta][:count]).to eq(0)
    end
  end

  describe "GET /api/v1/posters/:id" do
    it "returns a single poster" do
      get "/api/v1/posters/#{@poster1.id}" # https://curriculum.turing.edu/module2/lessons/building_an_api
      
      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data][:id]).to eq(@poster1.id.to_s)
      expect(parsed_response[:data][:attributes][:name]).to eq("DISASTER")
    end
    
    it "404 handler" do
      get "/api/v1/posters/404"
      
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "POST /api/v1/posters" do
    it "creates a new poster" do
      poster_params = {
        name: "ANXIETY",
        description: "is this test good?",
        price: 3.00,
        year: 2025,
        vintage: false,
        img_url: "https://rough.jpg",
      }
      
      post "/api/v1/posters", params: poster_params
      
      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data][:attributes][:name]).to eq("ANXIETY")
      
      expect(Poster.last.name).to eq("ANXIETY")
    end
    
    it "ignores extra parameters" do
      poster_params = {
        name: "ANXIETY",
        description: "is this test good?",
        price: 3.00,
        year: 2025,
        vintage: false,
        img_url: "https://rough.jpg",
        extra_field: "IGNORE ME!!!"
      }
      
      post "/api/v1/posters", params: poster_params
      
      expect(response).to be_successful # no 404
      expect(Poster.last.respond_to?(:extra_field)).to be false
    end
  end
  
  describe "PATCH /api/v1/posters/:id" do
    it "updates a poster" do
      patch_params = {
        name: "UPDATED POSTER",
        price: 25.00
      }
      
      patch "/api/v1/posters/#{@poster3.id}", params: patch_params
      
      expect(response).to be_successful
      
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data][:attributes][:name]).to eq("UPDATED POSTER")
      expect(parsed_response[:data][:attributes][:price]).to eq(25.0)
      expect(parsed_response[:data][:attributes][:description]).to eq("Bad choices")
      
      @poster3.reload
      expect(@poster3.name).to eq("UPDATED POSTER")
      expect(@poster3.price).to eq(25.0)
    end
    
    it "404 handler" do
      patch "/api/v1/posters/404", params: { name: "UPDATED" }
      
      expect(response).to have_http_status(:not_found)
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
      expect(Poster.count).to eq(4)
      
      delete "/api/v1/posters/#{@poster.id}"
      
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
      
      # Verify it was actually deleted from the database
      expect(Poster.count).to eq(3)
      expect(Poster.find_by(id: @poster.id)).to be_nil
    end
    
    it "404 handler" do
      delete "/api/v1/posters/404"
      
      expect(response).to have_http_status(:not_found)
    end
  end
end