module Oauth
  class QQ < Provider
    
    def fetch_info
      api_access('get_user_info')
    end

    def api_access(api, http_params = {}, http_method = 'get')
      url = 'https://graph.qq.com/user/' + api
      http_params.merge!({"access_token" => access_token, "openid"=> uid, "oauth_consumer_key" => Configure['qq']['appid']})
      Oauth::QQ.request(url, http_params, http_method, 'json')
    end

    class << self
      def authenticate?(access_token, uid)
        openid = self.openid(access_token)
        openid && (openid == uid)
      end

      def openid(access_token)
        str = get('https://graph.qq.com/oauth2.0/me', {access_token: access_token})
        if str
          str.match(%r{"openid":"([A-z0-9]{32})"}).try(:[], 1)
        end
      end

      def authorize_url
        get_params = {
          response_type: 'code',
          client_id: Configure['qq']['appid'],
          redirect_uri: Configure['qq']['callback'],
          state: 1,
          scope: 'get_user_info,get_info,do_like'
        }
        "https://graph.qq.com/oauth2.0/authorize?#{URI.encode_www_form(get_params)}"
      end

      def detail_of_code(code)
        get_params = {
          grant_type: 'authorization_code',
          client_id: Configure['qq']['appid'],
          client_secret: Configure['qq']['secret'],
          code: code,
          redirect_uri: Configure['qq']['callback']
        }
        response = getJSON('https://graph.qq.com/oauth2.0/token', get_params)
        if response # access_token=xxx&expires_in=7776000&refresh_token=xxx
          detail = Hash[response.split('&').map{|q| q.split('=')}]
          detail["created_at"] = Time.now
          detail['uid'] = openid(detail["access_token"]
          if detail['uid']
            detail
          else
            nil
          end
        else
          nil
        end
      end
    end

  end
  class QQMobile < QQ; end
end