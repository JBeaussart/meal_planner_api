module Api
  module V1
    class ScheduledRecipesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_scheduled_recipe, only: %i[update destroy]

      def index
        records = current_api_v1_user.scheduled_recipes.includes(:recipe)
        render json: ScheduledRecipeSerializer.new(records, include: [:recipe]).serializable_hash
      end

      # Upsert by day_of_week for current user
      def create
        day = permitted_params[:day_of_week]
        recipe_id = permitted_params[:recipe_id]
        unless day && !recipe_id.nil?
          return render json: { errors: ['day_of_week and recipe_id are required'] }, status: :unprocessable_entity
        end

        record = current_api_v1_user.scheduled_recipes.find_or_initialize_by(day_of_week: day)
        record.recipe_id = recipe_id
        if record.save
          render json: ScheduledRecipeSerializer.new(record, include: [:recipe]).serializable_hash, status: :created
        else
          render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        return head :forbidden unless @scheduled_recipe.user_id == current_api_v1_user.id

        if @scheduled_recipe.update(permitted_params)
          render json: ScheduledRecipeSerializer.new(@scheduled_recipe, include: [:recipe]).serializable_hash
        else
          render json: { errors: @scheduled_recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return head :forbidden unless @scheduled_recipe.user_id == current_api_v1_user.id

        @scheduled_recipe.destroy
        head :no_content
      end

      # DELETE /api/v1/scheduled_recipes/clear
      # Remove all scheduled recipes for current user
      def clear
        current_api_v1_user.scheduled_recipes.delete_all
        head :no_content
      end

      private

      def set_scheduled_recipe
        @scheduled_recipe = ScheduledRecipe.find(params[:id])
      end

      def permitted_params
        params.require(:scheduled_recipe).permit(:day_of_week, :recipe_id)
      end
    end
  end
end
