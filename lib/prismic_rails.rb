require 'prismic'
require 'rails'
require "prismic_rails/version"
require 'prismic_rails/railtie'
require "prismic_rails/helpers/view_helpers.rb"
require "prismic_rails/services/query_service.rb"
require "prismic_rails/services/language_service.rb"
require "prismic_rails/content/result.rb"
require "prismic_rails/content/document.rb"
require "prismic_rails/content/fragment.rb"
require "prismic_rails/content/nil_document.rb"

# :nodoc:
module PrismicRails

  class NoPrismicAPIConnection < StandardError; end

  # A simple Config class that holds the config objects
  class Config
    attr_accessor :url,       # Prismic API URL
      :token,                 # Prismic API Token :client_id,             # Client ID
      :client_secret,         # Client Secret
      :languages,             # Language maching hash
      :caching                # Changing enabled?
  end

  # Initalize the Config class
  def self.config
    @@config ||= Config.new
  end

  # Set the configs
  def self.configure
    yield self.config
  end

  # Returns the Prismic::API Object or nil if prismic.io is down
  def self.api
    begin
      Prismic.api(self.config.url, self.config.token)
    rescue Prismic::API::PrismicWSConnectionError,
      Prismic::API::BadPrismicResponseError,
      Prismic::API::PrismicWSAuthError,
      SocketError,
      Net::OpenTimeout
        raise NoPrismicAPIConnection
    end
  end

  # Get the master ref of prismic account. This is primarily used to establish a
  # caching mechanism.
  def self.ref
    if caching_enabled?
      get_cached_ref
    else
      get_ref
    end
  end

  # returns if the caching is enabled
  def self.caching_enabled?
    PrismicRails.config.caching
  end

  # Get the last cached master ref out of the rails cache if prismic is not available
  def self.get_cached_ref
    master_ref = get_ref
    Rails.cache.write('prismic_rails_ref', master_ref)
    master_ref
  rescue NoPrismicAPIConnection
    cached_ref = Rails.cache.fetch('prismic_rails_ref')
    raise NoPrismicAPIConnection if cached_ref.nil?
    cached_ref
  end

  # Get the master ref from the Prismic::API object
  def self.get_ref
    api.master_ref.ref
  end

end
