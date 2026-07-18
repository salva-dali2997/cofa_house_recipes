class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, -> { order(:id) }, dependent: :destroy
  has_many :feedbacks, -> { order(created_at: :desc) }, dependent: :destroy

  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :instructions, presence: true
end
