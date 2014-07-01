module FbGraph2
  class Auth < Rack::OAuth2::Client
    class Grant
      class FbExchangeToken < Rack::OAuth2::Client::Grant
        attr_required :fb_exchange_token
      end
    end

    def initialize(client_id, client_secret, options = {})
      super options.merge(
        identifier: client_id,
        secret: client_secret,
        host: URI.parse(FbGraph2.root_url).host,
        authorization_endpoint: '/oauth/authorize',
        token_endpoint: '/oauth/access_token'
      )
    end

    def fb_exchange_token=(access_token)
      @grant = Grant::FbExchangeToken.new(
        fb_exchange_token: access_token
      )
    end

    def access_token!(options = {})
      super options, client_auth_method: :body
    rescue Rack::OAuth2::Client::Error => e
      raise Exception.detect_from_status(detect_from_status).new(e.message)
    end
  end
end
