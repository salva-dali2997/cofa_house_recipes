class MenuRecipe < ApplicationRecord
  belongs_to :menu
  belongs_to :recipe

  validates :recipe_id, uniqueness: { scope: :menu_id }
end
