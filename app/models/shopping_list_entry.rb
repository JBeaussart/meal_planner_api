# == Schema Information
#
# Table name: shopping_list_entries
#
#  id              :bigint           not null, primary key
#  checked         :boolean          default(FALSE), not null
#  manual          :boolean          default(FALSE), not null
#  name            :string           not null
#  normalized_name :string           not null
#  normalized_unit :string
#  quantity        :integer
#  unit            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  idx_shopping_entries_uniqueness         (user_id,normalized_name,normalized_unit) UNIQUE
#  index_shopping_list_entries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ShoppingListEntry < ApplicationRecord
  belongs_to :user

  before_validation :normalize_fields

  validates :name, presence: true
  validates :normalized_name, presence: true
  validates :user_id, uniqueness: { scope: %i[normalized_name normalized_unit] }
  validates :quantity, numericality: { only_integer: true, allow_nil: true }

  scope :for_keys, ->(user_id, keys) do
    # keys: array of [normalized_name, normalized_unit]
    where(user_id: user_id).where(keys.map { |n, u| "(normalized_name = ? AND normalized_unit #{u.nil? ? 'IS NULL' : '= ?'})" }.join(' OR '), *keys.flatten.compact)
  end

  def self.normalize_value(v)
    v.present? ? v.to_s.strip.downcase : nil
  end

  private

  def normalize_fields
    self.normalized_name = self.class.normalize_value(name)
    self.normalized_unit = self.class.normalize_value(unit)
  end
end
