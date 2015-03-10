require 'mongoid'

module Mongoid
  module Xoauth
    extend ActiveSupport::Concern
    
    included do
      index "oauths.uid" => 1, "oauths._type" => 1
    end

    module ClassMethods
      def xoauth(params) # weibo_web/mobile: {appid, secret, callback}, qq: {key, secret}
        raise "invalid coauth params #{params.to_s}" unless params.is_a?(Hash)
        embeds_many :oauths, class_name: 'Oauth::Provider', as: :oauthable
        # config oauths
        params.each_pair{|key, param| Oauth::Configure[key.to_s] = param}
      end

      def find_by_oauth(oauth)
        where('oauths.uid' => oauth.uid, 'oauths._type' => oauth.class.to_s).first
      end
    end

    def oauth(klass)
      self.oauths.find_by(_type: klass.to_s) # "Oauth::#{name.to_s.capitalize}"
    end

    def refresh_oauth(oauth)
      auth = self.oauth(oauth.class)
      if auth.access_token == oauth.access_token
        # check expires_in
      else
        %w{access_token created_at expires_in refresh_token}.each do |key|
          auth[key] = oauth[key]
        end
      end
      auth
    end
  end
end