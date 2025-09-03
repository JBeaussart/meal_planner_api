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
class Recipe < ApplicationRecord
  # Association
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :scheduled_recipes, dependent: :destroy

  has_one_attached :image

  # Validation
  validates :title, presence: true

  enum taste: {
    salt: 0,
    sugar: 1
  }
end
