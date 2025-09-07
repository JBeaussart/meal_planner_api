# == Schema Information
#
# Table name: scheduled_recipes
#
#  id          :bigint           not null, primary key
#  day_of_week :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_scheduled_recipes_on_recipe_id                (recipe_id)
#  index_scheduled_recipes_on_user_id                  (user_id)
#  index_scheduled_recipes_on_user_id_and_day_of_week  (user_id,day_of_week) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#  fk_rails_...  (user_id => users.id)
#
# app/serializers/scheduled_recipe_serializer.rb
class ScheduledRecipeSerializer
  include JSONAPI::Serializer

  set_type :scheduled_recipe
  attributes :day_of_week, :created_at

  belongs_to :user
  belongs_to :recipe, serializer: RecipeSerializer
end
