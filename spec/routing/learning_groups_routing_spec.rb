require "spec_helper"

describe LearningGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/learning_groups").should route_to("learning_groups#index")
    end

    it "routes to #new" do
      get("/learning_groups/new").should route_to("learning_groups#new")
    end

    it "routes to #show" do
      get("/learning_groups/1").should route_to("learning_groups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/learning_groups/1/edit").should route_to("learning_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/learning_groups").should route_to("learning_groups#create")
    end

    it "routes to #update" do
      put("/learning_groups/1").should route_to("learning_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/learning_groups/1").should route_to("learning_groups#destroy", :id => "1")
    end

  end
end
