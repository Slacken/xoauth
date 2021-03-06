module Oauth
  class Info
    include Mongoid::Document
    has_one :oauth, class_name: 'Oauth::Provider', inverse_of: :info

    field :data, type: Hash, default: {}
  end
end