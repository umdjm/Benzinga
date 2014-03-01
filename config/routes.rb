StockPicker::Application.routes.draw do

  root to: 'stock_results#show'

  get '/results/:day', to: 'stock_results#show'

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
