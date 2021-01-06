# frozen_string_literal: true

require "spec_helper"

RSpec.describe BitgoClient::V2 do
  subject(:api) { described_class.new(WebmockHelper::TOKEN) }

  let(:client) { instance_double("BitgoClient::Client", request: "request result") }

  let(:wallet_id) { "5ac4f3131f0945" }

  before do
    allow(BitgoClient::Client).to receive(:new).with(WebmockHelper::TOKEN).and_return client
  end

  describe "#base_path" do
    context "with default environment" do
      it "uses the test path" do
        expect(api.base_path).to eq BitgoClient::V2::PATH_TEST
      end
    end

    context "with production environment" do
      subject(:api) { described_class.new(WebmockHelper::TOKEN, env: BitgoClient::V2::ENV_PROD) }

      it "uses the production path" do
        expect(api.base_path).to eq BitgoClient::V2::PATH_PROD
      end
    end
  end

  describe "#express_path" do
    context "with default path" do
      specify { expect(api.express_path).to eq "http://localhost:3080" }
    end

    context "with a custom path" do
      subject(:api) { described_class.new(WebmockHelper::TOKEN, express_path: custom_path) }

      let(:custom_path) { "http://test.path" }

      it "uses the custom path" do
        expect(api.express_path).to eq custom_path
      end
    end
  end

  describe "#client" do
    it "returns the client instance" do
      expect(api.client).to eq client
    end
  end

  describe "#wallet" do
    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.wallet(wallet_id)

        expect(client).to have_received(:request).with("#{api.base_path}/tbtc/wallet/#{wallet_id}?", logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.wallet(wallet_id, coin_code: :xxx)

        expect(client).to have_received(:request).with("#{api.base_path}/xxx/wallet/#{wallet_id}?", logger: nil, proxy: nil)
      end
    end
  end

  describe "#create_address" do
    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.create_address(wallet_id)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/address", method: :post, logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.create_address(wallet_id, coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/address", method: :post, logger: nil, proxy: nil)
      end
    end
  end

  describe "#address" do
    let(:address) { "njDyqXz0nd2bbZ" }

    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.address(wallet_id, address)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/address/#{address}", logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.address(wallet_id, address, coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/address/#{address}", logger: nil, proxy: nil)
      end
    end
  end

  describe "#send_transaction" do
    let(:payload) { { key: :value } }

    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.send_transaction(wallet_id, payload)

        expect(client).to have_received(:request)
          .with("#{api.express_path}/api/v2/tbtc/wallet/#{wallet_id}/sendcoins", payload, method: :post, logger: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.send_transaction(wallet_id, payload, coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.express_path}/api/v2/xxx/wallet/#{wallet_id}/sendcoins", payload, method: :post, logger: nil)
      end
    end
  end

  describe "#transactions" do
    context "with default params" do
      it "calls client request with the correct path" do
        api.transactions(wallet_id)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/tx?limit=25", logger: nil, proxy: nil)
      end
    end

    context "with specific params" do
      it "calls client request with the correct path" do
        api.transactions(wallet_id, coin_code: :xxx, limit: 250, prev_id: "xxx42", all_tokens: true)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/tx?allTokens=true&limit=250&prevId=xxx42", logger: nil, proxy: nil)
      end
    end
  end

  describe "#transaction" do
    let(:tx_id) { "0x888" }

    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.transaction(wallet_id, tx_id)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/tx/#{tx_id}", logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.transaction(wallet_id, tx_id, coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/tx/#{tx_id}", logger: nil, proxy: nil)
      end
    end
  end

  describe "#fee" do
    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.fee

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/tx/fee", logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.fee(coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/tx/fee", logger: nil, proxy: nil)
      end
    end
  end

  describe "#transfers" do
    context "with default params" do
      it "calls client request with the correct path" do
        api.transfers(wallet_id)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/transfer?limit=25", logger: nil, proxy: nil)
      end
    end

    context "with specific params" do
      it "calls client request with the correct path" do
        api.transfers(wallet_id, coin_code: :xxx, limit: 250, prev_id: "xxx42", all_tokens: true)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/transfer?allTokens=true&limit=250&prevId=xxx42", logger: nil, proxy: nil)
      end
    end
  end

  describe "#get_transfer" do
    let(:tx_id) { "0x888" }

    context "with default coin_code" do
      it "calls client request with the correct path" do
        api.get_transfer(wallet_id, tx_id)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/tbtc/wallet/#{wallet_id}/transfer/#{tx_id}", logger: nil, proxy: nil)
      end
    end

    context "with specific coin_code" do
      it "calls client request with the correct path" do
        api.get_transfer(wallet_id, tx_id, coin_code: :xxx)

        expect(client).to have_received(:request)
          .with("#{api.base_path}/xxx/wallet/#{wallet_id}/transfer/#{tx_id}", logger: nil, proxy: nil)
      end
    end
  end
end
