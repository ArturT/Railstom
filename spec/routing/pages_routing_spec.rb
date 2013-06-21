require 'spec_helper'

describe 'routes for /:locale/pages/*id' do
  it { expect(get '/pl/pages/contact').to route_to('pages#locale_show', locale: 'pl', id: 'contact') }
  it { expect(get '/en/pages/about').to route_to('pages#locale_show', locale: 'en', id: 'about') }
end
