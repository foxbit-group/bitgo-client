# frozen_string_literal: true

require "spec_helper"

RSpec.describe BitgoClient::Client do
  subject(:client) { described_class.new(WebmockHelper::TOKEN) }

  let(:base_path) { WebmockHelper::BASE_PATH }
  let(:headers) do
    {
      "Authorization" => "Bearer #{WebmockHelper::TOKEN}",
      "Content-Type"  => "application/json"
    }
  end

  describe "#request" do
    let(:path) { "#{base_path}/some-resource" }

    before do
      stub_request(:get, path).to_return(status: 200, body: '{"key":"value"}')
    end

    it "do a get request with the basic structure" do
      client.request(path)

      expect(WebMock)
        .to have_requested(:get, path)
        .with(headers: headers)
    end

    it "parse the response as hash" do
      expect(client.request(path)).to eq "key" => "value"
    end

    context "with a post method" do
      before { stub_request(:post, path).to_return(status: 200, body: "{}") }

      it "do a post request with the basic structure" do
        client.request(path, method: :post)

        expect(WebMock)
          .to have_requested(:post, path)
          .with(headers: headers)
      end
    end

    context "with payload" do
      let(:payload) { { xxx: 42 } }

      let(:payload_json) { payload.to_json }

      before { stub_request(:post, path).to_return(status: 200, body: "{}") }

      it "do a post request passing the payload in JSON format" do
        client.request(path, payload, method: :post)

        expect(WebMock)
          .to have_requested(:post, path)
          .with(headers: headers, body: payload_json)
      end
    end

    context "with a server error" do
      before { stub_request(:get, path).to_return(status: 500, body: "") }

      it "raises a specific error" do
        expect { client.request(path) }.to raise_error BitgoClient::Errors::RequestError
      end

      it "raises an error with response property" do
        begin
          client.request(path)
        rescue BitgoClient::Errors::RequestError => error
          expect(error.response.class).to eq Typhoeus::Response
        end
      end
    end
  end
end
