Rails.application.routes.draw do
  root to: "game#index"
  get "/play" => "game#new", as: :new_game
  devise_for :users, controllers: { registrations: 'registrations' }
end
