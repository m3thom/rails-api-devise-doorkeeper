Rails.application.routes.draw do
  resources :posts
  devise_for :users,
             controllers: {
                 registrations: 'users/registrations',
             }
  use_doorkeeper do
    skip_controllers :authorizations,
                     :applications,
                     :authorized_applications
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
