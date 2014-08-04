require 'spec_helper'

describe 'Active Admin Features', :js do
  let(:admin) { create(:admin) }

  before do
    login_as(admin)

    within 'nav.top-bar' do
      click_link 'Admin'
    end
  end

  it 'login to admin panel and logout' do
    expect(page).to have_content admin.email
    expect(page).to have_content 'Powered by Active Admin'

    within '#logout' do
      click_link 'Logout'
    end

    expect(page).to have_content I18n.t('controllers.application.flash.you_are_not_an_admin')
  end

  describe 'Users', :local_off do
    let!(:user) { create(:user) }

    before do
      within '#header' do
        click_link 'User'
      end
    end

    it 'set admin flag for user' do
      within "#user_#{user.id}" do
        click_link 'Edit'
      end

      check 'user_admin'
      click_on 'Update User'

      expect(page).to have_content 'User was successfully updated'
      expect(User.find_by(id: user.id).admin).to be true
    end
  end
end
