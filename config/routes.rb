Rails.application.routes.draw do
  root 'home#top'
  devise_for :users, controllers: { registrations: 'registrations' },
    :controllers => {
      :registrations => 'users/registrations',
      :sessions => 'users/sessions'
    }

  devise_scope :users do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
  end

  get 'users/show'
end
