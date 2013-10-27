class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  inject :authentication_service, :user_service, :user_repository, :omniauth_hash

  def facebook
    handle_omniauth(:facebook)
  end

  private

  def handle_omniauth(provider_name)
    # Find an authentication or if no authentication was found, create a brand new one here
    authentication = authentication_service.find_or_build

    if user_signed_in?
      link_current_user_with_authentication(authentication)
    else
      if authentication_service.has_user?(authentication)
        # The authentication we found had a user associated with it so let's
        # just log them in here
        sign_in_and_redirect_with_notice(authentication.user, provider_name)
      else
        user = user_repository.find_with_omniauth

        if user.present?
          redirect_to new_user_session_path, notice: t('controllers.omniauth_callbacks.flash.sign_in_before_link_account_html', email: omniauth_hash['info'].try(:[], 'email'), provider: provider_name)
        else
          # No user associated with the authentication so we need to create a new one
          user = user_service.build_with_omniauth

          if user.save
            # And assign it to authentication object
            authentication_service.user_link_with(authentication, user)

            # Finally log in the user
            sign_in_and_redirect_with_notice(user, provider_name)
          else
            session['devise.user.omniauth_data'] = omniauth_hash
            redirect_to new_user_registration_path, notice: t('controllers.omniauth_callbacks.flash.invalid_provider')
          end
        end
      end
    end
  end

  def link_current_user_with_authentication(authentication)
    if authentication_service.user_linked?(authentication)
      # User is signed in so they are trying to link an authentication with their
      # account. But we found the authentication and the user associated with it
      # is the current user. So the authentication is already associated with
      # this user. So let's display an error message.
      redirect_to root_path, notice: t('controllers.omniauth_callbacks.flash.already_linked_account')
    elsif authentication.new_record?
      # The authentication is not associated with the current_user so lets
      # associate the authentication
      authentication_service.user_link_with(authentication)
      redirect_to root_path, notice: t('controllers.omniauth_callbacks.flash.successfully_linked_account')
    else
      redirect_to root_path, notice: t('controllers.omniauth_callbacks.flash.provider_linked_with_other_account_html', provider: authentication.provider)
    end
  end

  def sign_in_and_redirect_with_notice(user, provider_name)
    sign_in_and_redirect user, event: :authentication # this will throw if user is not activated
    set_flash_message(:notice, :success, kind: provider_name.to_s.capitalize)
  end
end
