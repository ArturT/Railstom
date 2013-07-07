class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  private

  def set_locale
    if Locale.supported_language?(params[:locale])
      I18n.locale = params[:locale]
    else
      # remove unnecessary fake locale param from url
      redirect_to root_path, notice: t('controllers.application.notice.not_supported_language') unless params[:locale].blank?
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end


  def after_sign_in_path_for(resource_or_scope)
    # Define here your sign in path
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    allowed_paths = [new_user_password_path]

    return resource_or_scope if allowed_paths.include?(resource_or_scope)
    root_path
  end
end
