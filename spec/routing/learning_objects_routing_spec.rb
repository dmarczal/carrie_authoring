require "spec_helper"

describe LearningObjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/learning_objects").should route_to("learning_objects#index")
    end

    it "routes to #new" do
      get("/learning_objects/new").should route_to("learning_objects#new")
    end

    it "routes to #show" do
      get("/learning_objects/1").should route_to("learning_objects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/learning_objects/1/edit").should route_to("learning_objects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/learning_objects").should route_to("learning_objects#create")
    end

    it "routes to #update" do
      put("/learning_objects/1").should route_to("learning_objects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/learning_objects/1").should route_to("learning_objects#destroy", :id => "1")
    end

  end
end
