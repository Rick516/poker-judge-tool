Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/cards', to: 'cards#top'
  post 'cards/check', to: 'cards#check'
  get 'cards/check', to: 'cards#top'
  get 'cards/result', to: 'cards#top'
  get 'cards/error', to: 'cards#top'

  mount API::Base => '/'
end
