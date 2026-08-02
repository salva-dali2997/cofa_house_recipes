class MenusController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]

  def show
    @menu = Menu.current
  end

  def new
    @menu = Menu.find_by(date: Date.current) || Menu.new(date: Date.current)
    @recipes = Recipe.order(:name)
  end

  def create
    @menu = Menu.find_or_initialize_by(date: menu_params[:date])
    @menu.recipe_ids = menu_params[:recipe_ids] || []
    if @menu.save
      redirect_to today_menu_path, notice: "Today's menu is set."
    else
      @recipes = Recipe.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  private
    def menu_params
      params.expect(menu: [ :date, recipe_ids: [] ])
    end
end
