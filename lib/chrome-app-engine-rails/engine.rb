puts "LOAD #{__FILE__}"

module ChromeAppEngineRails

  class Engine < Rails::Engine

    config.chrome_app = ::ChromeAppEngineRails.config

  end

end
