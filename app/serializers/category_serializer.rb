# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# app/serializers/category_serializer.rb
class CategorySerializer
  include JSONAPI::Serializer

  set_type :category
  attributes :name, :created_at

  has_many :steps
end
