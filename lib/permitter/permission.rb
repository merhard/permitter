module Permitter
  module Permission
    def allowed_action?(controller, action, resource = nil)
      if allow_all?
        true
      elsif @allowed_actions
        allowed = @allowed_actions[[controller.to_s, action.to_s]]
        !!(allowed && (allowed == true || resource && allowed.call(resource)))
      else
        false
      end
    end

    def allowed_param?(resource, attribute)
      if allow_all?
        true
      elsif @allowed_params && @allowed_params[resource]
        @allowed_params[resource].include? attribute
      else
        false
      end
    end

    def allowed_action(controller, action)
      @allowed_actions[[controller.to_s, action.to_s]] if @allowed_actions
    end

    def allow_action(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).flatten.each do |controller|
        Array(actions).flatten.each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    def allow_param(resources, attributes)
      @allowed_params ||= {}
      resource_array = Array(resources).flatten
      attribute_array = Array(attributes).flatten

      resource_array.each do |resource|
        @allowed_params[resource] ||= []
        @allowed_params[resource] += attribute_array
      end
    end

    def allow_all
      @allow_all = true
    end

    def allow_all?
      @allow_all ||= false
    end

    def permit_params!(params)
      if @allow_all
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end
  end
end
