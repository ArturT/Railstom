require 'spec_helper'

describe 'Railstom Features', :railstom, :js do
  let(:anchor) { '' }

  before do
    visit page_path(I18n.locale, 'railstom', anchor: anchor)
  end

  def wait_for_animation
    sleep 1 # wait until scrolling animation finish
  end

  describe 'AngularJS' do
    describe 'Templates' do
      it 'render test-angular-template' do
        within 'test-angular-template' do
          expect(page).to have_content('Angular Template. Language:')
        end
      end
    end

    describe 'maxCharacters shows' do
      before do
        expect(find('#form_example_second_message').value).to be_blank
      end

      it 'amount of remaning characters' do
        within '.form_example_second_message' do
          expect(page).to have_content(I18n.t('layouts.application.words.characters_remaining', amount: 15))

          fill_in 'form_example_second_message', with: 'Hello'

          expect(page).to have_content(I18n.t('layouts.application.words.characters_remaining', amount: 10))
        end
      end

      it 'too long text message' do
        within '.form_example_second_message' do
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
        wait_for_animation

        expect(page.evaluate_script('window.scrollY')).to be > 10
        expect(page.evaluate_script('window.scrollY')).to be < 60
      end
    end

    describe 'loadIcon after click link' do
      it 'shows in specified element' do
        expect(find('#icon_load_goes_here').value).to be_blank

        click_link 'Load icon in specified element'

        within '#icon_load_goes_here' do
          expect(page).to have_xpath("//i[contains(@class,'icon-spin')]")
        end
      end

      it 'shows append' do
        within '#load_me' do
          click_link 'Load me'

          expect(page).to have_xpath("//i[contains(@class,'icon-spin')]")
        end
      end
    end
  end

  describe 'JS Features' do
    describe 'sign up modal' do
      it 'shows up' do
        expect(page).not_to have_selector '#signUpModal'

        click_link 'Sign up'

        within '#signUpModal' do
          expect(page).to have_link 'Registration form'
        end
      end
    end

    describe 'lazyImageLoader' do
      it 'load image after scroll to it' do
        expect(page).to have_xpath("//img[@id='check_sign'][@data-deferred='/assets/check.png']")
        expect(page).to have_xpath("//img[@id='check_sign'][@src='/assets/spinner.png']")

        # scroll to bottom where image is placed
        page.execute_script('window.scrollBy(0,10000)')

        expect(page).to have_xpath("//img[@id='check_sign'][@src='/assets/check.png']")
      end
    end

    describe 'scroll to anchor' do
      let(:anchor) { '_footer_breadcrumbs' }

      it 'should change scroll top' do
        wait_for_animation
        scroll_top = page.evaluate_script('$(window).scrollTop()')
        expect(scroll_top).to be >= 800
      end
    end
  end
end
