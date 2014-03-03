module Permitter
  module ModelAdditions
    extend ActiveSupport::Concern

    included do
      require 'squeel'
    end

    module ClassMethods
      def permitted_by(permissions, action = :show)
        if permissions.allow_all?
          all
        else
          permitted_relation(permissions.allowed_action(table_name, action))
        end
      end

      private

      def permitted_relation(allowed_action)
        if allowed_action.class == Proc
          where(&allowed_action)
        elsif allowed_action.present?
          all
        else
          none
        end
      end
    end
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Permitter::ModelAdditions
  end
end
