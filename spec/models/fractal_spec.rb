require 'spec_helper'

describe Fractal do

  it { should have_fields(:name, :angle, :axiom, :constant, :rules) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:angle) }
  it { should validate_presence_of(:axiom) }
  it { should validate_presence_of(:rules) }
end
