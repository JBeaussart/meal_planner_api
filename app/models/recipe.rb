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
#
class Recipe < ApplicationRecord
  has_one_attached :images

  enum taste: {
    salt: 0,
    sugar: 1
  }
end
