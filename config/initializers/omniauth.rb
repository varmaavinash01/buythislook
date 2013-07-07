Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Settings.facebook["app_key"], Settings.facebook["app_secrete"]
end