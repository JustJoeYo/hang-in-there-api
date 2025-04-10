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

    end
    
    it "formats the JSON response correctly" do

    end
    
    it "filters posters by name" do

    end
    
    it "filters posters by minimum price" do
      
    end
    
    it "filters posters by maximum price" do
      
    end
    
    it "sorts posters by created_at in ascending order" do
      
    end
    
    it "sorts posters by created_at in descending order" do
      
    end
    
    it "combines filtering and sorting parameters" do
      
    end
    
    it "returns an empty array when no posters match the criteria" do
      
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