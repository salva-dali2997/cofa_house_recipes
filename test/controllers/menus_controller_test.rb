require "test_helper"

class MenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @recipe = recipes(:one)
  end

  test "show is public" do
    get today_menu_path
    assert_response :success
  end

  test "show renders empty state when no menu exists" do
    Menu.destroy_all

    get today_menu_path
    assert_response :success
    assert_select "p.empty-state"
  end

  test "show renders the most recent menu" do
    Menu.create!(date: Date.new(2026, 7, 19)).recipe_ids = [ @recipe.id ]
    Menu.create!(date: Date.new(2026, 8, 2)).recipe_ids = [ @recipe.id ]

    get today_menu_path
    assert_response :success
    assert_select "h1", "Cofa House August 2nd 2026"
  end

  test "new requires authentication" do
    get new_menu_path
    assert_redirected_to new_session_path
  end

  test "create requires authentication" do
    assert_no_difference "Menu.count" do
      post menus_path, params: { menu: { date: "2026-08-02", recipe_ids: [ @recipe.id ] } }
    end
    assert_redirected_to new_session_path
  end

  test "signed in user can set today's menu" do
    sign_in_as @user

    assert_difference "Menu.count", 1 do
      post menus_path, params: { menu: { date: "2026-08-02", recipe_ids: [ @recipe.id ] } }
    end

    assert_redirected_to today_menu_path
    menu = Menu.find_by(date: Date.new(2026, 8, 2))
    assert_equal [ @recipe ], menu.recipes
  end

  test "re-submitting a date updates the existing menu's recipes" do
    sign_in_as @user
    other_recipe = recipes(:two)
    existing = Menu.create!(date: Date.new(2026, 8, 2))
    existing.recipe_ids = [ @recipe.id ]

    assert_no_difference "Menu.count" do
      post menus_path, params: { menu: { date: "2026-08-02", recipe_ids: [ other_recipe.id ] } }
    end

    assert_equal [ other_recipe ], existing.reload.recipes
  end
end
