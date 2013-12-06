class Permission
  include Permitter::Permission

  def initialize(user)
    allow_action :projects, :index

    if user
      allow_action :projects, [:show, :new, :create]

      allow_action :projects, [:edit, :update] do |project|
        project.user_id == user.id
      end
    end

  end

end
