Abiteapp::Application.routes.draw do

  resources :notifications do
    member do
      get :forward
    end
  end
  resources :places
  resources :rooms do
    member do
      post :message
    end
  end
  resources :seats
  resources :tables do
    member do
      post :join
      get :mark_complete
      get :permalink
    end
  end
  resources :users

  root to: 'seats#explore'

  # Notifications
  match '/news', to: 'notifications#news', as: 'news'
  match '/clear-news', to: 'notifications#clear_news', as: 'clear_news'

  # Pages
  match 'about', to: 'pages#about', as: 'about'
  match 'test', to: 'pages#test', as: 'test'
  match 'yelp', to: 'pages#yelp', as: 'yelp'

  # Seats
  match 'explore', to: 'seats#explore', as: 'explore'
  match 'sitting', to: 'seats#sitting', as: 'sitting'
  match 'sitting-switch', to: 'seats#sitting_switch', as: 'sitting_switch'

  # Sessions
  match 'auth', to: 'sessions#auth', as: 'auth'
  match 'sign-in', to: 'sessions#new', as: 'sign_in'
  match 'sign-out', to: 'sessions#destroy', as: 'sign_out'

  # Tables
  match 'start', to: 'tables#start', as: 'start'

  # Users
  match 'update-location', to: 'users#update_location', as: 'update_location'

  match '*url' , to: 'seats#explore', as: 'page_not_found'

end
