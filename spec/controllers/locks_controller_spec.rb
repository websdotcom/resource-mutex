require "spec_helper"
require "pp"

RSpec.describe LocksController, type: :controller do
  describe "create" do
    context "when the resource is available" do
      let(:owner)   { "Prince Jason" }

      before(:each) do
        post :create, { resource_name: "water", owner: owner }
      end

      it "responds with status 200" do
        expect(response.status).to eq 200
      end

      it "responds with the JSON of the lock object" do
        response_body = JSON.parse(response.body)

        expect(response_body["id"]).to          be_present
        expect(response_body["resource_id"]).to be_present
        expect(response_body["owner"]).to       eq owner
      end
    end

    context "when the resource is unavailable" do
      let(:resource) { FactoryGirl.create(:resource, name: "natural gas") }
      let(:owner)    { "Stingy John" }

      before(:each) do
        Lock.create!(resource_id: resource.id, owner: owner)

        post :create, { resource_name: "water", owner: owner }
      end

      it "responds with status 409" do
        expect(response.status).to eq 409
      end
    end
  end
end