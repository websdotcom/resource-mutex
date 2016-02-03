require "spec_helper"
require "pp"

RSpec.describe LocksController, type: :controller do
  describe "create" do
    it "does stuff" do
      post :create, { resource_name: "water", owner: "Jason" }

      pp JSON.parse(response.body)
    end
  end
end