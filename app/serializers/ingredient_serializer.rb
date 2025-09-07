# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  quantity   :integer
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_ingredients_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
# app/serializers/ingredient_serializer.rb
class IngredientSerializer
  include JSONAPI::Serializer

  set_type :ingredient
  attributes :name, :quantity, :unit, :created_at

  belongs_to :recipe
end
