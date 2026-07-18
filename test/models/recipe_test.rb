require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "requires a name" do
    recipe = Recipe.new(instructions: "Do it.", user: users(:one))
    assert_not recipe.valid?
    assert_includes recipe.errors[:name], "can't be blank"
  end

  test "requires instructions" do
    recipe = Recipe.new(name: "Chili", user: users(:one))
    assert_not recipe.valid?
    assert_includes recipe.errors[:instructions], "can't be blank"
  end

  test "destroying a recipe destroys its ingredients and feedback" do
    recipe = recipes(:one)
    ingredient_count = recipe.ingredients.count
    feedback_count = recipe.feedbacks.count
    assert ingredient_count > 0
    assert feedback_count > 0

    assert_difference "Ingredient.count", -ingredient_count do
      assert_difference "Feedback.count", -feedback_count do
        recipe.destroy
      end
    end
  end
end
