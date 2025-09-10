# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  made_by_mom :boolean          default(FALSE)
#  taste       :integer          default("salt")
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# app/serializers/recipe_serializer.rb
class RecipeSerializer
  include JSONAPI::Serializer

  set_type :recipe
  attributes :title, :made_by_mom, :created_at

  # Ensure taste is serialized as the enum integer (0: salt, 1: sugar)
  attribute :taste do |object|
    object[:taste]
  end

  attribute :image_url do |object|
    next nil unless object.image.attached?

    # Return path-only to avoid host config; RN can prefix API base URL
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)
  end

  belongs_to :user
  has_many :ingredients, serializer: IngredientSerializer
  has_many :steps, serializer: StepSerializer
  has_many :scheduled_recipes, serializer: ScheduledRecipeSerializer
end
