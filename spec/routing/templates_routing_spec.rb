require 'spec_helper'

describe 'routes for /templates/*id' do
  it { expect(get '/templates/test').to route_to('templates#show', id: 'test') }
end
