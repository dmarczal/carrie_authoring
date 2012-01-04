require 'spec_helper'

describe ExercisesController do
  describe "GET index" do
    it "assigns all exercises from a learning_object" do
      exercise = Fabricate(:exercise)
      get :show
      assigns(:exercise).should eq([exercise])
    end
  end
end
