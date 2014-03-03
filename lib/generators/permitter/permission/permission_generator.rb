module Permitter
  module Generators
    class PermissionGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_permission
        copy_file 'permission.rb', 'app/models/permission.rb'
        if File.exist?(File.join(destination_root, 'spec'))
          copy_file 'permission_spec.rb', 'spec/models/permission_spec.rb'
        end
      end
    end
  end
end
