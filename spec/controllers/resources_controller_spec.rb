require "spec_helper"

RSpec.describe ResourcesController, type: :controller do
  describe "create" do
    context "when the resource is created successfully" do
      let(:resource_name)   { "water" }

      before(:each) do
        post :create, { name: resource_name }
      end

      it "responds with status code 201" do
        expect(response.status).to eq 201
      end

      it "responds with the JSON of the newly-created resource" do
        parsed_response = JSON.parse(response.body)

        expect(parsed_response["id"]).to         be_present
        expect(parsed_response["name"]).to       eq resource_name
        expect(parsed_response["created_at"]).to be_present
        expect(parsed_response["updated_at"]).to  be_present
      end
    end

    context "when the resource creation fails" do
      before(:each) do
        post :create, { }
      end

      it "responds with status code 500" do
        expect(response.status).to eq 500
      end

      it "responds with JSON containing the errors" do
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end
  end
end
