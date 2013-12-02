class Permission
  include Permitter::Permission

  def initialize(user)
    # Define permissions for the passed in (current) user. For example:
    #
    #   if user
    #     allow_all
    #   else
    #     allow_action [:sessions, :registrations], [:new, :create]
    #     allow_action :sessions, :destroy
    #   end
    #
    # Here if there is a user he will be able to perform any action on any controller.
    # If someone is not logged in he can only access the registrations and sessions controllers.
    #
    # The first argument to `allow_action` is the controller name being permitted. The second
    # argument is the action they can perform in that controller. Passing an array to either of
    # these will grant permission on each item in the array.
    #
  end
end
