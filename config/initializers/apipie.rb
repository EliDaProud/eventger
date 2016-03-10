Apipie.configure do |config|
  config.app_name                = "Eventger"
  config.doc_base_url            = "/apipie"
  config.validate                = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
