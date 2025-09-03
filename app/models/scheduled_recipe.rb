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
