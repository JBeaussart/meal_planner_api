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
      head :forbidden unless current_user.respond_to?(:admin?) && current_user.admin?
    end
  end
end
