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
    end

    def find_by_oauth_uid(uid, klass)
      where('oauths.uid' => uid.to_s, 'oauths._type' => klass.to_s).first
    end

    def oauth(klass)
      self.oauths.find_by(_type: klass.to_s) # "Oauth::#{name.to_s.capitalize}"
    end
  end
end