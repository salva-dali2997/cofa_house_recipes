require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  test "requires a name and quantity" do
    ingredient = Ingredient.new(recipe: recipes(:one))
    assert_not ingredient.valid?
    assert_includes ingredient.errors[:name], "can't be blank"
    assert_includes ingredient.errors[:quantity], "can't be blank"
  end
end
