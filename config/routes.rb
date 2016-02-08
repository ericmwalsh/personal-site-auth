Rails.application.routes.draw do

  # authentication
  devise_for :admins, controllers: { sessions: 'sessions' }
  devise_scope :admin do
    get "admins/authenticate" => "sessions#authenticate_via_token"
  end

end
