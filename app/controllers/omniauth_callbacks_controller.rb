class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    handle_omniauth(:facebook)
  end

  private

  def handle_omniauth(provider_name)
    auth = request.env['omniauth.auth']

    # Find an authentication or if no authentication was found, create a brand new one here
    authentication = Authentication.find_with_omniauth(auth) || Authentication.build_with_omniauth(auth)

    if user_signed_in?
      if authentication.user == current_user
        # User is signed in so they are trying to link an authentication with their
        # account. But we found the authentication and the user associated with it
        # is the current user. So the authentication is already associated with
        # this user. So let's display an error message.
        redirect_to root_path, notice: t('controllers.omniauth_callbacks.flash.already_linked_account')
      else
        # The authentication is not associated with the current_user so lets
        # associate the authentication
        authentication.user = current_user
        authentication.save!
        redirect_to root_path, notice: t('controllers.omniauth_callbacks.flash.successfully_linked_account')
      end
    else
      if authentication.user.present?
        # The authentication we found had a user associated with it so let's
        # just log them in here
        sign_in_and_redirect authentication.user, :event => :authentication # this will throw if user is not activated
        set_flash_message(:notice, :success, :kind => provider_name.to_s.capitalize)
      else
        # No user associated with the authentication so we need to create a new one
        user = User.build_with_omniauth(auth)

        if user.valid?
          user.save!

          # And assign it to authentication object
          authentication.user = user
          authentication.save!

          # Finally log in the user
          sign_in_and_redirect user, :event => :authentication # this will throw if user is not activated
          set_flash_message(:notice, :success, :kind => provider_name.to_s.capitalize)
        else
          session['devise.user.omniauth_data'] = auth
          redirect_to new_user_registration_path, notice: t('controllers.omniauth_callbacks.flash.invalid_provider')
        end
      end
    end
  end
end
