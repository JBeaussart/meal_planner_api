# app/controllers/api/v1/registrations_controller.rb
module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      # (facultatif) petit log debug
      before_action do
        Rails.logger.info("[DEBUG] params: #{params.inspect}")
      end

      # On réimplémente create pour NE PAS faire sign_in(resource)
      def create
        build_resource(sign_up_params)

        if resource.save
          render json: { id: resource.id, email: resource.email }, status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      protected

      # Devise appelle normalement cette méthode pour auto-login :
      # on la neutralise pour être 100% stateless.
      def sign_up(_resource_name, _resource)
        # no-op (pas d'auto sign-in après signup)
      end

      # Params autorisés (robuste)
      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def account_update_params
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
      end
    end
  end
end
