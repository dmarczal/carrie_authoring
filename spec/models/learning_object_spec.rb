require 'spec_helper'

describe LearningObject do
  it { should have_fields(:name, :description) }
  it { should have_many(:exercises).with_dependent(:delete) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:description) }
end
