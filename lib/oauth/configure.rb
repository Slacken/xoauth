module Oauth
  class Configure
    @@value = {}

    def self.[]=(key, value)
      @@value[key] = value
    end

    def self.[](key)
      @@value[key]
    end

    def self.value
      @@value
    end
  end
end