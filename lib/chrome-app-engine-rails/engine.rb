module ChromeAppEngineRails

  class Engine < Rails::Engine

    config.chrome_app = ::ChromeAppEngineRails.config

  end

end
