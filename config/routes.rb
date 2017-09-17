Rails.application.routes.draw do

  get 'admin', to: 'static#index'

  get 'hotspot_customer', to: 'hotspot_customer#index'
  get '/hotspot_customer/show_log', to: 'hotspot_customer#show_log'

  get 'hotspot_customer/new'

  get 'hotspot_customer/create'

  get 'hotspot_customer/show'

  get 'hotspot_customer/update'

  get 'hotspot_customer/edit'

  get 'router/index'
  get 'router', to: 'router#index'
  get 'router/new'
  post 'router/create'
  get 'router/destroy'

  get '/router/:id', to: 'router#show'
  get '/router/edit/:id', to: 'router#edit'
  patch '/router/edit/:id', to: 'router#update'

  get 'wifi/index'

  get 'wifi/login'
  post 'wifi/login', to: 'wifi#login_post'

  get 'wifi/logout'

  get 'wifi/registration'
  post 'wifi/registration', to: 'wifi#registration_post'

  get 'wifi/agreement'
  get 'wifi/check'

  root 'wifi#agreement'


  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
