class RegistrationsController < Devise::RegistrationsController
  before_action :check_if_password_changed, only: [:edit, :update]

  def reset_password
    sign_out :user
    redirect_to new_user_password_path
  end

  private

  def check_if_password_changed
    @show_change_password_form = current_user.password_changed?
  end
end
