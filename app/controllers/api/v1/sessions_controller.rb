module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      # Quand le login réussit → Devise::JWT ajoute déjà le header Authorization
      def respond_with(resource, _opts = {})
        render json: {
          status: { code: 200, message: 'Signed in successfully.' },
          data: {
            id: resource.id,
            email: resource.email
          }
        }, status: :ok
      end

      # Quand on fait un logout
      def respond_to_on_destroy
        if current_api_v1_user
          render json: {
            status: 200,
            message: 'Signed out successfully.'
          }, status: :ok
        else
          render json: {
            status: 401,
            message: 'User has no active session.'
          }, status: :unauthorized
        end
      end
    end
  end
end
