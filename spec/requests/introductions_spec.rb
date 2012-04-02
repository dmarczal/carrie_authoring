require 'spec_helper'

describe "Introductions" do
  describe "GET /introductions" do
    it "works! (now write some real specs)" do
      pending
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get introductions_path
      response.status.should be(200)
    end
  end
end
