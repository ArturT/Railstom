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

end
