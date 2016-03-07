Rails.application.routes.draw do

  # authentication
  devise_for :users, controllers: { sessions: 'sessions' }
  devise_scope :user do
    get "users/authenticate" => "sessions#authenticate_via_token"
  end

end
