require 'spec_helper'

describe 'Railstom Features', :railstom, :js do
  let(:user) { create(:user_confirmed) }

  before do
    login_as(user)
    visit page_path(I18n.locale, 'railstom')
  end

  describe 'AngularJS Templates' do
    it 'render test-angular-template' do
      within('test-angular-template') do
        expect(page).to have_content('Angular Template. Language:')
      end
    end
  end
end
