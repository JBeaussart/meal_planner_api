# app/controllers/api/v1/recipes_controller.rb
module Api
  module V1
    class RecipesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_recipe, only: %i[show update destroy]

      def index
        recipes = current_api_v1_user.recipes.order(created_at: :desc)
        render json: RecipeSerializer.new(recipes).serializable_hash
      end

      def show
        render json: RecipeSerializer.new(@recipe, include: %i[ingredients steps]).serializable_hash
      end

      def create
        permitted = recipe_params
        # Avoid ActiveStorage trying to interpret an arbitrary string as a signed_id
        permitted = sanitize_image_param(permitted)
        recipe = current_api_v1_user.recipes.new(permitted)
        if recipe.save
          render json: RecipeSerializer.new(recipe).serializable_hash, status: :created
        else
          render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        # Allow removing the current image with a flag
        if ActiveModel::Type::Boolean.new.cast(params.dig(:recipe, :remove_image)) && @recipe.image.attached?
          @recipe.image.purge_later
        end

        permitted = recipe_params
        permitted = sanitize_image_param(permitted)
        if @recipe.update(permitted)
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
        @recipe = current_api_v1_user.recipes.find(params[:id])
      end

      def recipe_params
        params.require(:recipe).permit(
          :title,
          :made_by_mom,
          :taste,
          :image,
          ingredients_attributes: %i[id name quantity unit _destroy],
          steps_attributes: %i[id description position category_id _destroy]
        )
      end

      # If image is a non-empty String and not an uploaded file/signed id, drop it.
      def sanitize_image_param(permitted)
        img = permitted[:image]
        if img.is_a?(String) && img.present?
          # Active Storage signed IDs are typically base64-like and long; we ignore unexpected strings
          permitted = permitted.dup
          permitted.delete(:image)
        end
        permitted
      end
    end
  end
end
