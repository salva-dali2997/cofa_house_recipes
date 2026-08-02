require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "requires a date" do
    menu = Menu.new
    assert_not menu.valid?
    assert_includes menu.errors[:date], "can't be blank"
  end

  test "date must be unique" do
    Menu.create!(date: Date.new(2026, 8, 2))
    menu = Menu.new(date: Date.new(2026, 8, 2))
    assert_not menu.valid?
    assert_includes menu.errors[:date], "has already been taken"
  end

  test "current returns the menu with the latest date" do
    older = Menu.create!(date: Date.new(2026, 7, 19))
    newer = Menu.create!(date: Date.new(2026, 8, 2))

    assert_equal newer, Menu.current
    assert_not_equal older, Menu.current
  end

  test "title formats the date" do
    menu = Menu.new(date: Date.new(2026, 8, 2))
    assert_equal "Cofa House August 2nd 2026", menu.title
  end

  test "recipes can be assigned by id before the menu is saved" do
    recipe = recipes(:one)
    menu = Menu.new(date: Date.new(2026, 8, 2))
    menu.recipe_ids = [ recipe.id ]

    assert menu.save
    assert_equal [ recipe ], menu.recipes
  end

  test "destroying a menu destroys its menu_recipes but not the recipes" do
    recipe = recipes(:one)
    menu = Menu.create!(date: Date.new(2026, 8, 2))
    menu.recipe_ids = [ recipe.id ]

    assert_difference "MenuRecipe.count", -1 do
      assert_no_difference "Recipe.count" do
        menu.destroy
      end
    end
  end
end
