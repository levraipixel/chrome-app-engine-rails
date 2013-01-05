puts "LOAD #{__FILE__}"

module ChromeAppEngineRails

  def self.config
    @config ||= ::ChromeAppEngineRails::Configuration.new
  end

  class Configuration

    def initialize
      self.on_compile = Proc.new{}
      self.assets = []
      self.filename = 'chrome_app'
      self.version = '0.0.1'
      self.keys = {
        production: 'config/chrome_app.pem'
      }
      self.src_path = 'app/chrome'
      self.build_path = 'lib/chrome'
      self.dev_folder = 'dev'
      self.tmp_path = 'tmp/chrome'
      self.dev_host = 'http://localhost:3000'
      self.tmp_assets_prefix = 'temp_assets_for_chrome_app'
      self.chrome_build_env = 'CHROME_APP_BUILD'
      self.host = nil
    end

    attr_accessor :build_path
    attr_accessor :src_path
    attr_accessor :tmp_path
    attr_accessor :dev_folder
    attr_accessor :on_compile
    attr_accessor :assets
    attr_accessor :filename
    attr_accessor :version
    attr_accessor :keys
    attr_accessor :host
    attr_accessor :dev_host
    attr_accessor :chrome_build_env
    attr_accessor :tmp_assets_prefix

  end

end