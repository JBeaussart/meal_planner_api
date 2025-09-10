Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 defaults: { format: :json },
                 path: '',
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions'
                 },
                 path_names: {
                   sign_in: 'users/sign_in',
                   sign_out: 'users/sign_out',
                   registration: 'users'
                 }

      resources :users, only: %i[index show]
      resources :recipes
      resources :scheduled_recipes, only: %i[index create update destroy] do
        collection do
          delete :clear
        end
      end
    end
  end
end
