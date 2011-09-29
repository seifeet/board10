require "spec_helper"

describe UserSchoolsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_schools").should route_to("user_schools#index")
    end

    it "routes to #new" do
      get("/user_schools/new").should route_to("user_schools#new")
    end

    it "routes to #show" do
      get("/user_schools/1").should route_to("user_schools#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_schools/1/edit").should route_to("user_schools#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_schools").should route_to("user_schools#create")
    end

    it "routes to #update" do
      put("/user_schools/1").should route_to("user_schools#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_schools/1").should route_to("user_schools#destroy", :id => "1")
    end

  end
end
