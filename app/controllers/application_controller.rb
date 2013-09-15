class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :logout_blocked_user
  before_action :set_locale
  around_action :set_time_zone

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller? && resource_name == :user && (
      # registration
      action_name == 'new' || action_name == 'create' ||
      # change password. Only for logout user because this action_names are also used on user_edit_registration_path
      ((action_name == 'edit' || action_name == 'update') && !user_signed_in?)
    )
      # TODO you can use 'standalone' template instead of 'application' template for login/registrations forms.
      # Please create standalone template and change this line
      'application'
    else
      'application'
    end
  end

  def logout_blocked_user
    if current_user && current_user.blocked?
      sign_out :user
      flash[:notice] = t('controllers.application.flash.your_account_is_blocked')
      redirect_to after_sign_out_path_for(current_user)
    end
  end

  def set_locale
    locale_request = if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
                       nil
                     else
                       request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
                     end

    if params[:locale].nil? && Locale.supported_language?(session[:locale])
      I18n.locale = session[:locale]
    elsif params[:locale].nil? && Locale.supported_language?(locale_request)
      I18n.locale = locale_request
      session[:locale] = I18n.locale
    elsif Locale.supported_language?(params[:locale])
      I18n.locale = params[:locale]
      session[:locale] = I18n.locale
    else
      # remove unnecessary fake locale param from url
      redirect_to root_path, notice: t('controllers.application.flash.not_supported_language') unless params[:locale].blank?
    end
  end

  def set_time_zone
    default_time_zone = Time.zone
    Time.zone = browser_time_zone if browser_time_zone.present?
    yield
  ensure
    Time.zone = default_time_zone
  end

  def browser_time_zone
    time_zone = cookies['browser.time_zone']
    if time_zone.present? && ActiveSupport::TimeZone::MAPPING.values.include?(time_zone)
      time_zone
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def authenticate_admin_user!
    unless current_user && current_user.admin?
      flash[:notice] = t('controllers.application.flash.you_are_not_an_admin')
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    # TODO Define here your sign in path
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    allowed_paths = [new_user_password_path]

    return resource_or_scope if allowed_paths.include?(resource_or_scope)
    root_path
  end
end
