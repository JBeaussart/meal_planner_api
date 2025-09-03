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
class Step < ApplicationRecord
  belongs_to :recipe
  belongs_to :category, optional: true

  validates :position,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
end
