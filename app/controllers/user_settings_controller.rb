class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      flash.now[:success] = t('.successfully_saved')
    end
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :avatar_cache, :remove_avatar)
  end
end
