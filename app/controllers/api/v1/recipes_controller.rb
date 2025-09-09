# app/controllers/api/v1/recipes_controller.rb
module Api
  module V1
    class RecipesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_recipe, only: %i[show update destroy]

      def index
        recipes = current_user.recipes.order(created_at: :desc)
        render json: RecipeSerializer.new(recipes).serializable_hash
      end

      def show
        render json: RecipeSerializer.new(@recipe).serializable_hash
      end

      def create
        recipe = current_user.recipes.new(recipe_params)
        if recipe.save
          render json: RecipeSerializer.new(recipe).serializable_hash, status: :created
        else
          render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @recipe.update(recipe_params)
          render json: RecipeSerializer.new(@recipe).serializable_hash
        else
          render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @recipe.destroy
        head :no_content
      end

      private

      def set_recipe
        @recipe = current_user.recipes.find(params[:id])
      end

      def recipe_params
        params.require(:recipe).permit(:title, :made_by_mom, :taste)
      end
    end
  end
end
