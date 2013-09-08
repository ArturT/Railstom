require 'spec_helper'

describe Newsletter do
  subject { build(:newsletter) }

  it { should be_valid }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }
  its(:enabled_force) { should be_false }
  its(:stopped) { should be_false }
  its(:last_user_id) { should eql 0 }
end
