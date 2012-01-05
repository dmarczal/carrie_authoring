require 'spec_helper'

describe Exercise do

  before(:each) do
    @learning_object = Fabricate(:learning_object)
  end
  it { should have_fields(:title, :enunciation, :position) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:enunciation) }

  it { should validate_uniqueness_of(:title) }

  it { should validate_associated(:fractal) }
  it { should validate_associated(:learning_object) }

  it { should embed_many(:questions) }
  it { should be_referenced_in(:fractal) }
  it { should be_referenced_in(:learning_object) }

  it "should set the position 1 when the Exercise are create" do
    exercise = Fabricate(:exercise, :learning_object => @learning_object)
    exercise.position.should == 1
  end

  it "should set the position greater then the last position created" do
    2.times { Fabricate(:exercise, :learning_object => @learning_object) }
    exercise = Fabricate(:exercise, :learning_object => @learning_object)
    exercise.position.should == 3
  end
end
