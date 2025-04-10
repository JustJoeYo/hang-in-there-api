Rails.application.routes.draw do
  get "/api/v1/posters", to: "api/v1/posters#index"
  get "/api/v1/posters/:id", to: "api/v1/posters#show"
  post "/api/v1/posters", to: "api/v1/posters#create"
  patch '/api/v1/posters/:id', to: "api/v1/posters#update"
  delete '/api/v1/posters/:id', to: "api/v1/posters#destroy"
end