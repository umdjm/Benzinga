StockPicker::Application.routes.draw do

  devise_for :users
  resources :stock_picks
  root to: 'stock_results#show'

  get '/results/:day', to: 'stock_results#show'
  get '/results', to: 'stock_results#show'
end
