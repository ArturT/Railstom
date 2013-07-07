require 'spec_helper'

describe 'routes for /:locale/cancel_accounts' do
  it { expect(get '/en/cancel_accounts/edit').to route_to('cancel_accounts#edit', locale: 'en') }
  it { expect(delete '/en/cancel_accounts').to route_to('cancel_accounts#destroy', locale: 'en') }
end

