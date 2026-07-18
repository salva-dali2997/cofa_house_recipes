require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @recipe = recipes(:one)
  end

  test "index is public" do
    get recipes_path
    assert_response :success
  end

  test "show is public" do
    get recipe_path(@recipe)
    assert_response :success
  end

  test "new requires authentication" do
    get new_recipe_path
    assert_redirected_to new_session_path
  end

  test "create requires authentication" do
    assert_no_difference "Recipe.count" do
      post recipes_path, params: { recipe: { name: "Chili", instructions: "Cook it." } }
    end
    assert_redirected_to new_session_path
  end

  test "signed in user can create a recipe with ingredients" do
    sign_in_as @user

    assert_difference "Recipe.count", 1 do
      assert_difference "Ingredient.count", 1 do
        post recipes_path, params: {
          recipe: {
            name: "Chili",
            instructions: "Cook it.",
            ingredients_attributes: { "0" => { name: "beans", quantity: "1 can" } }
          }
        }
      end
    end

    assert_redirected_to recipe_path(Recipe.last)
    assert_equal @user, Recipe.last.user
  end

  test "cannot edit another user's recipe" do
    sign_in_as users(:two)

    get edit_recipe_path(@recipe)
    assert_redirected_to recipe_path(@recipe)
  end

  test "owner can update their recipe" do
    sign_in_as @user

    patch recipe_path(@recipe), params: { recipe: { name: "Updated name" } }
    assert_redirected_to recipe_path(@recipe)
    assert_equal "Updated name", @recipe.reload.name
  end

  test "owner can destroy their recipe" do
    sign_in_as @user

    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
  end
end
