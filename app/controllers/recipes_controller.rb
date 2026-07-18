class RecipesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_recipe, only: %i[ show edit update destroy ]
  before_action :require_owner, only: %i[ edit update destroy ]

  def index
    @recipes = Recipe.all.order(created_at: :desc)
  end

  def show
    @feedback = Feedback.new
  end

  def new
    @recipe = Current.user.recipes.build
    3.times { @recipe.ingredients.build }
  end

  def create
    @recipe = Current.user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Recipe created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe.ingredients.build if @recipe.ingredients.empty?
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted.", status: :see_other
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def require_owner
      redirect_to @recipe, alert: "You can only edit your own recipes." unless @recipe.user == Current.user
    end

    def recipe_params
      params.expect(recipe: [ :name, :instructions, ingredients_attributes: [ [ :id, :name, :quantity, :_destroy ] ] ])
    end
end
