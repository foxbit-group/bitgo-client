# frozen_string_literal: true

module BitgoClient
  class V2
    ENV_PROD  = "prod"
    ENV_TEST  = "test"
    PATH_PROD = "https://www.bitgo.com/api/v2"
    PATH_TEST = "https://test.bitgo.com/api/v2"

    attr_reader :access_token, :env, :express_path

    def initialize(access_token, env: ENV_TEST, express_path: "http://localhost:3080")
      @access_token = access_token
      @env          = env
      @express_path = express_path
    end

    def base_path
      env == ENV_PROD ? PATH_PROD : PATH_TEST
    end

    def client
      BitgoClient::Client.new(access_token)
    end

    def wallet(wallet_id, coin_code: :tbtc)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}")
    end

    def create_address(wallet_id, coin_code: :tbtc)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/address", method: :post)
    end

    def address(wallet_id, address, coin_code: :tbtc)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/address/#{address}")
    end

    def send_transaction(wallet_id, payload, coin_code: :tbtc)
      client.request("#{express_path}/api/v2/#{coin_code}/wallet/#{wallet_id}/sendcoins", payload, method: :post)
    end

    def transactions(wallet_id, coin_code: :tbtc)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/tx")
    end

    def transaction(wallet_id, transaction_id, coin_code: :tbtc)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/tx/#{transaction_id}")
    end
  end
end
