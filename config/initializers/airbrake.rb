# -*- encoding : utf-8 -*-
Airbrake.configure do |config|
  config.api_key = APP_CONFIG['airbrake_api_key']
end rescue nil
