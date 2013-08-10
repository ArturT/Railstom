require 'spec_helper'

describe TemplatesController do
  subject { response }

  describe '#show' do
    let(:template_id) { 'test' }

    before do
      get :show, id: template_id
    end

    it { should be_success }
    it { should render_template(template_id) }
  end
end
