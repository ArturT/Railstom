require 'spec_helper'

describe 'Railstom Features', :railstom, :js do
  let(:user) { create(:user_confirmed) }

  before do
    login_as(user)
    visit page_path(I18n.locale, 'railstom')
  end

  describe 'AngularJS' do
    describe 'Templates' do
      it 'render test-angular-template' do
        within('test-angular-template') do
          expect(page).to have_content('Angular Template. Language:')
        end
      end
    end

    describe 'maxCharacters' do
      it 'amount of remaning characters change' do
        within('.form_example_second_message') do
          expect(find('#form_example_second_message').value).to be_blank
          expect(page).to have_content(I18n.t('layouts.application.words.characters_remaining', amount: 15))

          fill_in 'form_example_second_message', with: 'Hello'
          expect(page).to have_content(I18n.t('layouts.application.words.characters_remaining', amount: 10))

          fill_in 'form_example_second_message', with: 'This text is really long :-)'
          expect(page).to have_content(I18n.t('layouts.application.words.too_long_text'))
        end
      end
    end

    describe 'goToByScroll' do
      it 'scrolls to the element' do
        expect(page.evaluate_script('window.scrollY')).to eql 0
        # scroll to bottom
        page.execute_script('window.scrollBy(0,10000)')
        expect(page.evaluate_script('window.scrollY')).to be > 500

        click_link('Go up')
        sleep 1 # wait until scrolling animation finish

        expect(page.evaluate_script('window.scrollY')).to be > 10
        expect(page.evaluate_script('window.scrollY')).to be < 50
      end
    end
  end

  describe 'JS Features' do
    describe 'lazyImageLoader' do
      it 'load image after scroll to it' do
        expect(page).to have_xpath("//img[@id='check_sign'][@data-deferred='/assets/check.png']")
        expect(page).to have_xpath("//img[@id='check_sign'][@src='/assets/spinner.png']")

        # scroll to bottom where image is placed
        page.execute_script "window.scrollBy(0,10000)"

        expect(page).to have_xpath("//img[@id='check_sign'][@src='/assets/check.png']")
      end
    end
  end
end
