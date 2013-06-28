require 'spec_helper'

describe TemplatesController do
  subject { response }

  describe '#show' do
    before do
      get :show, id: 'test'
    end

    it { should be_success }
    it { should render_template(page) }
  end
end
