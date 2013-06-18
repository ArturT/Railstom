require 'spec_helper'

describe 'routes for /' do
  it { expect(get '/').to route_to("home#locale_root") }
  it { expect(get '/en').to route_to("home#index", locale: 'en') }
  it { expect(get '/pl').to route_to("home#index", locale: 'pl') }
end
