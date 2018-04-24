# frozen_string_literal: true

module BitgoClient
  class Client
    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def request(url, payload = nil, method: :get)
      request = Typhoeus::Request.new(
        url,
        method: method,
        headers: {
          "Authorization" => "Bearer #{access_token}",
          "Content-Type"  => "application/json"
        },
        body: (payload ? payload.to_json : nil)
      )

      request.run

      response = request.response

      raise BitgoClient::Errors::RequestError.new("BitGo API response error.", response) if response.failure?

      JSON.parse(response.body)
    end
  end
end
