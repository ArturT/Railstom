require 'spec_helper'

shared_examples 'sidekiq returns routing error' do
  it 'returns ActionController::RoutingError' do
    expect {
      get '/sidekiq'
    }.to raise_exception(ActionController::RoutingError)
  end
end

describe 'Sidekiq Requests' do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  subject { response }

  describe 'GET /sidekiq' do
    context 'when user is logged in' do
      context 'when user is admin' do
        before do
          login_as(admin)
          get '/sidekiq'
        end

        it { should be_success }
      end

      context 'when user is not admin' do
        before { login_as(user) }

        it_behaves_like 'sidekiq returns routing error'
      end
    end

    context 'when user is logged out' do
      it_behaves_like 'sidekiq returns routing error'
    end
  end
end
