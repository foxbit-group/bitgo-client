# frozen_string_literal: true

require "logger"

module BitgoClient
  class Client
    SENSITIVE_KEYS = [
      :backupXpub,
      :keychain,
      :newWalletPassphrase,
      :otp,
      :overrideEncryptedPrv,
      :passcodeEncryptionCode,
      :passphrase,
      :password,
      :prv,
      :pub,
      :userKey,
      :userPassword,
      :walletPassphrase,
      :xprv,
    ]

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def request(url, payload = nil, method: :get, logger: nil, proxy: nil)
      body = payload.to_json if payload

      log logger, "Request url: #{url}, method: #{method}, body:"

      options = {
        method: method,
        headers: {
          "Authorization" => "Bearer #{access_token}",
          "Content-Type"  => "application/json"
        },
        body: body
      }

      unless String(proxy).empty?
        options[:proxy] = proxy
      end

      request = Typhoeus::Request.new(url, options)
      request.run

      response = request.response

      code = response.code
      body = response.body

      log logger, "Response code: '#{code}', body: '#{body}'"

      if [408, 504, 524].include?(code)
        raise BitgoClient::Errors::RequestError.new("[BitGo API Error] Timeout (code: #{code}).", response)
      elsif response.failure?
        raise BitgoClient::Errors::RequestError.new("[BitGo API Error] code: #{code}.", response)
      elsif body.nil? || body == ""
        {}
      elsif valid_json?(body)
        JSON.parse(body)
      else
        raise BitgoClient::Errors::RequestError.new("[BitGo API Error] Invalid JSON (code: #{code}).", response)
      end
    end

    private

    def log(logger, message)
      return if logger.nil?

      if message.is_a?(Hash)
        SENSITIVE_KEYS.each { |key| message[key] = "[FILTERED]" if message.key?(key) }
        message = message.to_json
      end

      tag = "#{self.class}/request"

      if logger.respond_to?(:tagged)
        logger.tagged(tag) { logger.debug(message) }
      else
        logger.debug(tag) { message }
      end
    end

    def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end
end
