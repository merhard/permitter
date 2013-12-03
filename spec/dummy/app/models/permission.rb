class Permission
  include Permitter::Permission

  def initialize(user)
    allow_action :foo, :bar
  end
end
