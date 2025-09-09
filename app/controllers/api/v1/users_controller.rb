# app/controllers/api/v1/users_controller.rb
module Api::V1
  class UsersController < ApplicationController
    def index
      users = User.order(created_at: :desc)
      render json: UserSerializer.new(users).serializable_hash
    end

    def show
      user = User.find(params[:id])
      render json: UserSerializer.new(user).serializable_hash
    end

    private

    def ensure_admin!
      user = respond_to?(:current_api_v1_user) ? current_api_v1_user : nil
      head :forbidden unless user&.respond_to?(:admin?) && user&.admin?
    end
  end
end
