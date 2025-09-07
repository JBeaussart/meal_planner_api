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
class ScheduledRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  enum day_of_week: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  validates :day_of_week, presence: true
  validates :user_id, uniqueness: { scope: :day_of_week }
end
