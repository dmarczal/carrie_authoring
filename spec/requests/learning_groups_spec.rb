require 'spec_helper'

describe "LearningGroups" do
  describe "GET /learning_groups" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get learning_groups_path
      response.status.should be(200)
    end
  end
end
