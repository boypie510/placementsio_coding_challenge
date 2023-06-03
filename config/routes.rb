# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :line_items, only: %i[index update]

  resources :campaigns do
    member do
      post :export_invoice
    end
  end
end
