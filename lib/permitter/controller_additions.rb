require 'active_support/concern'

module Permitter
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do

      delegate :allow_action?, to: :current_permission
      helper_method :allow_action?

      delegate :allow_param?, to: :current_permission
      helper_method :allow_param?

      def current_permissions
        @current_permissions ||= ::Permission.new(current_user)
      end
      helper_method :current_permissions

      private

      def authorize(*args)
        if current_permissions.allowed_action?(*args)
          current_permissions.permit_params!(params) #TODO: work?
        else
          raise Permitter::Unauthorized
        end
      end

      def current_resource
        nil
      end

      def allowed_action?(*args)
        current_permissions.allowed_action?(*args)
      end

      def allowed_param?(*args)
        current_permissions.allowed_param?(*args)
      end
    end


    module ClassMethods

      def enable_authorization(options = {}, &block)
        before_filter(options.slice(:only, :except)) do |controller|
          break if options[:if] && !controller.send(options[:if])
          break if options[:unless] && controller.send(options[:unless])
          controller.authorize(controller.params[:controller], controller.params[:action], controller.current_resource)
        end
      end

    end


  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Permitter::ControllerAdditions
  end
end
