source 'https://rubygems.org'

ruby '3.3.5'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
gem 'rack-cors'             # autoriser les requêtes cross-origin (React Native)

gem 'devise'                # gestion des utilisateurs (signup/login)
gem 'devise-jwt'            # support JWT pour API stateless

gem 'jsonapi-serializer'    # sérialisation rapide et standard JSON:API
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

gem 'annotate', group: :development                # ajoute les schémas DB en commentaires dans les modèles
gem 'pagy'                                         # pagination
gem 'rubocop', require: false, group: :development # linting/style Ruby

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Recherche avancée (plein texte sur Postgres)
gem 'pg_search'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'   # création d’objets de test (fixtures modernes)
  gem 'faker'               # générer des données factices
  gem 'pry-byebug'          # debug pas à pas
  gem 'pry-rails'           # console Rails améliorée
  gem 'rspec-rails'         # framework de tests
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
