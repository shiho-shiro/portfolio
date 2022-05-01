Rails.application.routes.draw do

  root 'home#top'
  devise_for :users,
    :controllers => {
      :registrations => 'users/registrations',
      :sessions => 'users/sessions'
    }

  devise_scope :users do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
  end

  resources :concerns do
    collection do
      get 'search'
    end
    resources :advices, only:[:create, :destroy]
  end

  resources :memories do
    member do
      get 'show_other_index'
    end
  end

  resources :recommends do
    collection do
      get 'search'
    end
    resource :likes, only:[:create, :destroy]
  end

  resources :users, only:[:show] do
    member do
      get 'show_other'
    end
  end

  resources :notifications, only: [:index, :destroy]
end
