class CancelAccountsController < ApplicationController
  inject :user_service

  before_action :authenticate_user!

  def edit
    flash.now[:warning] = t('controllers.cancel_accounts.flash.not_set_password_html', url: edit_user_registration_path) unless current_user.password_changed?
  end

  def destroy
    if current_user.valid_password?(params[:user][:current_password])
      user_service.cancel_account!
      sign_out :user
      flash[:success] = t('controllers.cancel_accounts.flash.account_deleted')
      redirect_to after_sign_out_path_for(current_user)
    else
      flash.now[:error] = t('controllers.cancel_accounts.flash.not_valid_password')
      render :edit
    end
  end
end
