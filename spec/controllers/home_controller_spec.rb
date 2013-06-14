require 'spec_helper'

describe HomeController do
  subject { response }

  describe 'GET #index' do
    before { get :index }

    it { should be_success }
    it { should render_template(:index) }
  end

end
