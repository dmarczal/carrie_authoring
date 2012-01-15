require "spec_helper"

describe IntroductionsController do
  describe "routing" do

    it "routes to #index" do
      get("/introductions").should route_to("introductions#index")
    end

    it "routes to #new" do
      get("/introductions/new").should route_to("introductions#new")
    end

    it "routes to #show" do
      get("/introductions/1").should route_to("introductions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/introductions/1/edit").should route_to("introductions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/introductions").should route_to("introductions#create")
    end

    it "routes to #update" do
      put("/introductions/1").should route_to("introductions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/introductions/1").should route_to("introductions#destroy", :id => "1")
    end

  end
end
