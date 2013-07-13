require 'spec_helper'

describe 'Active Admin Requests' do
  let(:admin) { create(:admin) }
  let(:user) { create(:user_confirmed) }

  subject { response }

  describe '#admin_root_path' do
    context 'when user is logged in' do
      context 'when user is admin' do
        before do
          login_as(admin)
          get admin_root_path
        end

        it { should be_success }
      end

      context 'when user is not admin' do
        before do
          login_as(user)
          get admin_root_path
        end

        it { should redirect_to root_path }
      end
    end

    context 'when user is logged out' do
      before { get admin_root_path }

      it { should redirect_to root_path }
    end
  end
end
