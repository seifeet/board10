require "spec_helper"

describe ScheduledEventsController do
  describe "routing" do

    it "routes to #index" do
      get("/scheduled_events").should route_to("scheduled_events#index")
    end

    it "routes to #new" do
      get("/scheduled_events/new").should route_to("scheduled_events#new")
    end

    it "routes to #show" do
      get("/scheduled_events/1").should route_to("scheduled_events#show", :id => "1")
    end

    it "routes to #edit" do
      get("/scheduled_events/1/edit").should route_to("scheduled_events#edit", :id => "1")
    end

    it "routes to #create" do
      post("/scheduled_events").should route_to("scheduled_events#create")
    end

    it "routes to #update" do
      put("/scheduled_events/1").should route_to("scheduled_events#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/scheduled_events/1").should route_to("scheduled_events#destroy", :id => "1")
    end

  end
end
