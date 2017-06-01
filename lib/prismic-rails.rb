require "prismic-rails/version"
require 'prismic-rails/railtie' if defined?(Rails)

module PrismicRails

  class Config
    attr_accessor :url, :token, :client_id, :client_secret
  end

  def self.config
    @@config || Config.new
  end

  def self.configure
    yield self.config
  end

end
