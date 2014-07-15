require 'rails_helper'

describe "validation" do
  let(:malformed_json) { "[" }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:data_without_title) { { "foo" => "bar"} }

  context "for manuals" do
    it "detects malformed JSON" do
      put '/hmrc-manuals/imaginary-slug', malformed_json, headers

      expect(response.status).to eq(400)
      expect(json_response).to include("status" => "error")
      expect(json_response["errors"].first).to match(%r{Request JSON could not be parsed:})
    end

    it "validates for the presence of the title" do
      put_json '/hmrc-manuals/imaginary-slug', data_without_title

      expect(response.status).to eq(422)
      expect(json_response).to include("status" => "error")
      expect(json_response["errors"].first).to match(%r{The property '#/' did not contain a required property of 'title' in schema})
    end
  end

  context "for manual sections" do
    it "detects malformed JSON" do
      put '/hmrc-manuals/imaginary-slug/sections/imaginary-section', malformed_json, headers

      expect(response.status).to eq(400)
      expect(json_response).to include("status" => "error")
      expect(json_response["errors"].first).to match(%r{Request JSON could not be parsed:})
    end

    it "validates for the presence of the title" do
      put_json '/hmrc-manuals/imaginary-slug/sections/imaginary-section', data_without_title

      expect(response.status).to eq(422)
      expect(json_response).to include("status" => "error")
      expect(json_response["errors"].first).to match(%r{The property '#/' did not contain a required property of 'title' in schema})
    end
  end
end
