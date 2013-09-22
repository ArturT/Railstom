require 'spec_helper'

describe UserRepository do
  let(:db_user) { User }
  let(:user) { build(:user) }
  let(:email) { 'email@example.com' }
  let(:omniauth_hash) do
    {
      'info' => {
        'email' => email
      }
    }
  end

  subject { isolate(UserRepository) }

  describe '#build' do
    its(:build) { should be_a(User)}
    its(:build) { should_not be_nil }
  end

  describe '#find_with_omniauth' do
    it 'returns user ' do
      expect(db_user).to receive(:find_by).with(email: email).and_return(user)
      expect(subject.find_with_omniauth).to eql user
    end
  end
end
