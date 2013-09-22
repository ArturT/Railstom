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

  def authentication
  end

  private

  def user_params
    permitted = [:avatar, :avatar_cache, :remove_avatar, :enabled_newsletter, :preferred_language]
    # don't update nickname if blank
    permitted << :nickname unless params[:user][:nickname].blank?
    params.require(:user).permit(*permitted)
  end
end
