require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "requires a comment" do
    feedback = Feedback.new(recipe: recipes(:one))
    assert_not feedback.valid?
    assert_includes feedback.errors[:comment], "can't be blank"
  end

  test "name is optional" do
    feedback = Feedback.new(recipe: recipes(:one), comment: "Yum")
    assert feedback.valid?
  end
end
