require 'spec_helper'

describe 'home/index.html.slim' do
  before { I18n.locale = :en }

  it 'view has content Hello World', :railstom do
    render
    expect(rendered).to have_content('Hello World')
  end
end
