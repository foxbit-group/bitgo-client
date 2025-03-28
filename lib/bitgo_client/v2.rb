# frozen_string_literal: true

require "addressable/uri"

module BitgoClient
  class V2
    ENV_PROD  = "prod"
    ENV_TEST  = "test"
    PATH_PROD = "https://www.bitgo.com/api/v2"
    PATH_TEST = "https://app.bitgo-test.com/api/v2"

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

    def create_address(wallet_id, coin_code: :tbtc, logger: nil)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/address", method: :post, logger: logger)
    end

    def address(wallet_id, address, coin_code: :tbtc, logger: nil)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/address/#{address}", logger: logger)
    end

    def fee(coin_code: :tbtc, logger: nil, tx: nil)
      query_string = build_query_string(tx: tx)

      client.request("#{base_path}/#{coin_code}/tx/fee?#{query_string}", logger: logger)
    end

    def get_transfer(wallet_id, transfer_id, coin_code: :tbtc, logger: nil)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/transfer/#{transfer_id}", logger: logger)
    end

    def send_transaction(wallet_id, payload, coin_code: :tbtc, logger: nil)
      client.request(
        "#{express_path}/api/v2/#{coin_code}/wallet/#{wallet_id}/sendcoins",
        payload,
        method: :post,
        logger: logger
      )
    end

    def transactions(wallet_id, coin_code: :tbtc, logger: nil, limit: 25, prev_id: nil, all_tokens: nil)
      query_string = build_query_string(
        limit:     limit,
        prevId:    prev_id,
        allTokens: all_tokens
      )

      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/tx?#{query_string}", logger: logger)
    end

    def transaction(wallet_id, transaction_id, coin_code: :tbtc, logger: nil)
      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/tx/#{transaction_id}", logger: logger)
    end

    def transfers(wallet_id, coin_code: :tbtc, logger: nil, limit: 25, prev_id: nil, all_tokens: nil)
      query_string = build_query_string(
        limit:     limit,
        prevId:    prev_id,
        allTokens: all_tokens
      )

      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}/transfer?#{query_string}", logger: logger)
    end

    def wallet(wallet_id, coin_code: :tbtc, logger: nil, all_tokens: nil)
      query_string = build_query_string(allTokens: all_tokens)

      client.request("#{base_path}/#{coin_code}/wallet/#{wallet_id}?#{query_string}", logger: logger)
    end

    def lightning_invoice(wallet_id, payload, logger: nil)
      client.request(
        "#{base_path}/wallet/#{wallet_id}/lightning/invoice",
        payload,
        method: :post,
        logger: logger
      )
    end

    def balance(coin_code: :tbtc, logger: nil)
      query_string = build_query_string(coin: coin_code)

      client.request("#{base_path}/wallet/balances?#{query_string}", logger: logger)
    end

    def wallets_by_currrency(coin_code: :tbtc, prevId: nil, logger: nil)
      query_string = build_query_string(coin: coin_code, prevId: prevId, skipReceiveAddress: true)

      client.request("#{base_path}/wallets?#{query_string}", logger: logger)
    end

    def get_pending_approvals(pending_approval_id, logger: nil)
      client.request("#{base_path}/pendingapprovals/#{pending_approval_id}", logger: logger)
    end

    private

    def build_query_string(hash)
      uri = Addressable::URI.new
      uri.query_values = hash.delete_if { |k, v| v.nil? }
      uri.query
    end
  end
end
