require 'net/http'
require 'uri'
require 'json'

module Oauth
  class Provider
    include Mongoid::Document
    field :access_token
    field :uid, type: String
    field :created_at, type: Time
    field :expires_in, type: Integer
    field :refresh_token

    embedded_in :oauthable, polymorphic: true, inverse_of: :oauth
    has_one :info, class_name: 'Oauth::Info', inverse_of: :oauth

    def fetch_info!
      return nil if expired?
      info = fetch_info
      if info
        self.info = Oauth::Info.new(data: info)
        self.save
      end
      self.info
    end

    def expired?
      created_at + expires_in < Time.now + 10
    end

    class << self
      def type
        self.to_s.split("::").last.downcase
      end
      # get/post/getJSON/postJSON
      ['get', 'post'].product([nil, 'json']).each do |method, format|
        define_method "#{method}#{format && format.upcase}", ->(url, params){ request(url, params, method, format) }
      end

      def request(url, request_params, method = 'get', format = nil)
        uri = URI(url)
        begin
          if method == 'get'
            uri.query = (uri.query.nil? ? '' : (uri.query + "&")) + URI.encode_www_form(request_params)
            response = Net::HTTP.get_response(uri)
          else
            response = Net::HTTP.post_form(uri, request_params)
          end
        rescue Exception => e
          puts e.message
          return nil
        end
        if response.kind_of? Net::HTTPSuccess
          format == 'json' ? JSON.parse(response.body) : response.body
        else
          nil
        end
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/provider/*.rb'].each {|file| require file }
