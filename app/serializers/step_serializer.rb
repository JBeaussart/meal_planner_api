# == Schema Information
#
# Table name: steps
#
#  id          :bigint           not null, primary key
#  description :text
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  recipe_id   :bigint           not null
#
# Indexes
#
#  index_steps_on_category_id  (category_id)
#  index_steps_on_recipe_id    (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (recipe_id => recipes.id)
#
# app/serializers/step_serializer.rb
class StepSerializer
  include JSONAPI::Serializer

  set_type :step
  attributes :position, :description, :created_at

  belongs_to :category, serializer: CategorySerializer
  belongs_to :recipe
end
