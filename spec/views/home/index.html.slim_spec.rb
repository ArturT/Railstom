require 'spec_helper'

describe 'home/index.html.slim' do
  it 'view has content Hello World' do
    render
    expect(rendered).to have_content('Hello World')
  end
end
