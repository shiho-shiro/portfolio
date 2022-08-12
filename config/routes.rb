Rails.application.routes.draw do
  root 'home#top'
  devise_for :users,
    :controllers => {
      :registrations => 'users/registrations',
      :sessions => 'users/sessions',
      passwords: 'users/passwords'
    }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#new_guest"
  end

  resources :concerns do
    collection do
      get 'search'
    end
    resources :advices, only: [:create, :destroy]
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
    resource :likes, only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    member do
      get 'show_other'
    end
  end

  resources :notifications, only: [:index, :destroy]
end
