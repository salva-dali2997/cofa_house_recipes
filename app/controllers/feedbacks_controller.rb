class FeedbacksController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  before_action :set_recipe

  def create
    @feedback = @recipe.feedbacks.build(feedback_params)
    if @feedback.save
      redirect_to @recipe, notice: "Thanks for your feedback!"
    else
      redirect_to @recipe, alert: @feedback.errors.full_messages.to_sentence
    end
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end

    def feedback_params
      params.expect(feedback: [ :name, :comment ])
    end
end
