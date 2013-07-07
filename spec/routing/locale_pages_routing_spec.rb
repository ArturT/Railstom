require 'spec_helper'

describe 'routes for /:locale/locale_pages/*id' do
  it { expect(get '/pl/locale_pages/contact').to route_to('pages#locale_show', locale: 'pl', id: 'contact') }
  it { expect(get '/en/locale_pages/about').to route_to('pages#locale_show', locale: 'en', id: 'about') }
end
