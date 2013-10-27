require 'spec_helper'

describe 'routes for /' do
  it { expect(get '/').to route_to("home#locale_root") }

  I18n.available_locales.each do |locale|
    it { expect(get "/#{locale}").to route_to("home#index", locale: locale.to_s) }
  end
end
