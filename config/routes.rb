Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/login", to: "session#new"
  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"
  resources :users
  resources :projects do
    resources :tasks, only: %i(create destroy new) do
      resources :cards, only: %i(new create)
    end
    member do
      get "/show_member", to: "projects#show_member"
      post "/add_member", to: "projects#add_member"
      delete "/delete_member", to: "projects#remove_member"
    end
  end
  resources :cards, only: %i(show edit update destroy) do
    resources :events, shallow: true
  end
end
