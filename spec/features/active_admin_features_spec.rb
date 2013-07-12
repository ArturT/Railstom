require 'spec_helper'

describe 'Active Admin Features', :js do
  let(:admin) { create(:admin) }

  before do
    login_as(admin)
  end

  it 'login to admin panel and logout' do
    within 'nav.top-bar' do
      click_link 'Admin'
    end

    expect(page).to have_content admin.email
    expect(page).to have_content 'Powered by Active Admin'

    within '#logout' do
      click_link 'Logout'
    end

    expect(page).to have_content I18n.t('controllers.application.notice.you_are_not_an_admin')
  end
end
