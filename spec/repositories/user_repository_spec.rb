require 'spec_helper'

describe UserRepository do
  let(:db_user) { User }
  let(:omniauth_hash) { Hash.new }

  subject { isolate(UserRepository) }

  describe '#build' do
    its(:build) { should be_a(User)}
    its(:build) { should_not be_nil }
  end
end
