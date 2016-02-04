require "spec_helper"
require "pp"

RSpec.describe LocksController, type: :controller do
  before(:each) do
    request.env["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic
      .encode_credentials(ENV["AUTH_NAME"], ENV["AUTH_PASSWORD"])
  end

  describe "create" do
    context "when the resource is available" do
      let(:owner) { "Prince Jason" }

      before(:each) do
        post :create, { resource_name: "water", owner: owner }
      end

      it "responds with status 200" do
        expect(response.status).to eq 200
      end

      it "responds with the JSON of the granted lock object" do
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

        post :create, { resource_name: resource.name, owner: owner }
      end

      it "responds with status 409" do
        expect(response.status).to eq 409
      end

      it "responds with the JSON of the conflicting lock object" do
        response_body = JSON.parse(response.body)

        expect(response_body["id"]).to          be_present
        expect(response_body["resource_id"]).to eq resource.id
        expect(response_body["owner"]).to       eq owner
        expect(response_body["created_at"]).to  be_present
        expect(response_body["updated_at"]).to  be_present
      end
    end
  end

  describe "destroy" do
    context "when the resource exists" do
      let(:resource) { FactoryGirl.create(:resource, name: "superprocessor") }

      before(:each) do
        Lock.create!(resource_id: resource.id, owner: "RSpec Test Girl")

        delete :destroy, { resource_name: resource.name }
      end

      it "responds with status 200" do
        expect(response.status).to eq 200
      end

      it "deletes the lock associated with the resource" do
        expect(resource.locks).to be_empty
      end
    end

    context "when the resource does not exist" do
      let(:resource_name) { "non-existent-resource" }

      before(:each) do
        delete :destroy, { resource_name: resource_name }
      end

      it "responds with status 404" do
        expect(response.status).to eq 404
      end

      it "responds with the expected error JSON" do
        response_body = JSON.parse(response.body)

        expect(response_body["errors"]).to eq "Unable to find resource with name \"#{resource_name}\""
      end
    end
  end
end
