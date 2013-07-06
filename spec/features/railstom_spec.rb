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
  end
end
