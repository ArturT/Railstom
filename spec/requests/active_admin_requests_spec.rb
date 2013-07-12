require 'spec_helper'

describe 'Active Admin Requests' do
  let(:admin) { create(:admin) }

  subject { response }

  describe '#admin_root_path' do
    context 'when user is admin' do
      before do
        login_as(admin)
        get admin_root_path
      end

      it { should be_success }
    end

    context 'when user is not admin' do
      before do
        get admin_root_path
      end

      it { should redirect_to root_path }
    end
  end
end
