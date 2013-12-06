class Permission
  include Permitter::Permission

  def initialize(user)
    allow_action :projects, :index
    if user
      allow_action :projects, [:show, :new]
    end
  end
end
