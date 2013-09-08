class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:success] = t('.successfully_saved')
      redirect_to edit_user_settings_url
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :avatar_cache, :remove_avatar, :enabled_newsletter, :preferred_language)
  end
end
