Rails.application.routes.draw do

  # authentication
  devise_for :admins, controllers: { sessions: 'sessions' }

end
