require 'spec_helper'

describe HomeController do
  subject { response }

  describe 'GET #index' do
    before { get :index, locale: I18n.locale }

    it { should be_success }
    it { should render_template(:index) }
  end

  describe 'GET #locale_root' do
    before { get :locale_root, locale: I18n.locale }

    it { should redirect_to(:root) }
  end
end
