# Setup your PrismicRails
PrismicRails.configure do |config|
  # Setup the basic API URL to Prismic.io
  config.url = ENV["PRISMIC_API_URL"]

  # Set the access token of prismic if you have one
  config.token = ENV["PRISMIC_ACCESS_TOKEN"]

  ## Language machting of your app locale to prismic locale:
  #  Example
  # config.languages = {
  #   'en' => 'en-us',
  #   'de' => 'de-ch',
  #   'fr' => 'fr-ch',
  #   'it' => 'it-ch'
  # }

  ## Set if PrismicRails should use rails caching
  config.caching = true
end
