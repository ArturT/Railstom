require 'spec_helper'

describe 'routes for /:locale/users' do
  it { expect(get '/en/users/reset_password').to route_to('registrations#reset_password', locale: 'en') }
end
