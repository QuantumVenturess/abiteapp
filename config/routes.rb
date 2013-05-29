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
      get  :change_date
      get  :date
      post :date
      post :join
      post :leave
      get  :mark_complete
      post :message
      get  :messages
      get  :permalink
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

  # Seats
  match 'explore', to: 'seats#explore', as: 'explore'
  match 'sitting', to: 'seats#sitting', as: 'sitting'
  match 'sitting-switch', to: 'seats#sitting_switch', as: 'sitting_switch'

  # Sessions
  match 'auth', to: 'sessions#auth', as: 'auth'
  match 'join', to: 'sessions#new', as: 'sign_in'
  match 'sign-out', to: 'sessions#destroy', as: 'sign_out'

  # Tables
  match 'start', to: 'tables#start', as: 'start'

  # Users
  match 'authenticate/bite-app', to: 'users#authenticate_bite_app'
  match 'authenticate/bite-access-token', to: 'users#bite_access_token'
  match 'read-tutorial', to: 'users#read_tutorial', as: 'read_tutorial'
  match 'update-location', to: 'users#update_location', as: 'update_location'

  match '*url' , to: 'seats#explore', as: 'page_not_found'

end
