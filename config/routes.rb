Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 defaults: { format: :json },
                 path: '',
                 controllers: {
                   registrations: 'api/v1/registrations'
                 },
                 path_names: {
                   sign_in: 'users/sign_in',
                   sign_out: 'users/sign_out',
                   registration: 'users'
                 }

      resources :users, only: %i[index show]
    end
  end
end
