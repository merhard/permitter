require 'active_support/concern'

module Permitter
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do

      delegate :allowed_action?, to: :current_permissions
      helper_method :allowed_action?

      delegate :allowed_param?, to: :current_permissions
      helper_method :allowed_param?

      private

      def authorize_user!
        args = [params[:controller], params[:action], current_resource]
        if current_permissions.allowed_action?(*args)
          current_permissions.permit_params!(params)
        else
          raise Permitter::Unauthorized
        end
      end

      def current_permissions
        @current_permissions ||= ::Permission.new(current_user)
      end

      def current_resource
        nil
      end

    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Permitter::ControllerAdditions
  end
end
