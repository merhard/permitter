module Permitter
  module ModelAdditions
    extend ActiveSupport::Concern

    included do
      require 'squeel'
    end

    module ClassMethods

      def permitted_by(permissions, action = :show)
        status = permissions.allow_all? ? true : permissions.allowed_action(self.table_name, action)

        if status.class == Proc
          where(&status)
        else
          status ? all : none
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
