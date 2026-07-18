require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup { @recipe = recipes(:one) }

  test "anyone can leave feedback without signing in" do
    assert_difference "@recipe.feedbacks.count" do
      post recipe_feedbacks_path(@recipe), params: { feedback: { name: "Jamie", comment: "Delicious!" } }
    end

    assert_redirected_to recipe_path(@recipe)
  end

  test "name is optional" do
    assert_difference "@recipe.feedbacks.count" do
      post recipe_feedbacks_path(@recipe), params: { feedback: { comment: "Delicious!" } }
    end
  end

  test "comment is required" do
    assert_no_difference "@recipe.feedbacks.count" do
      post recipe_feedbacks_path(@recipe), params: { feedback: { name: "Jamie", comment: "" } }
    end

    assert_redirected_to recipe_path(@recipe)
  end
end
