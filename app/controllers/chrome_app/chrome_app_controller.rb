module ChromeApp
  class ChromeAppController < ActionController::Base
  
    def current_version
      render :text => builder.config.version
    end
    
    def latest
      send_app_file builder.config.version
    end
    
    def by_version
      send_app_file params[:version]
    end
    
    def updates
      codebase = Rails.application.routes.url_helpers.chrome_app_current_version_url(
        host: builder.config.host,
        format: :crx
      )
      version = builder.config.version
      render :xml => "<?xml version='1.0' encoding='UTF-8'?>
  <gupdate xmlns='http://www.google.com/update2/response' protocol='2.0'>
    <app appid='jjlgkedbeplemkdnkbnlhpfmlkmnpcdo'>
      <updatecheck codebase='#{codebase}' version='#{version}' />
    </app>
  </gupdate>"
    end
    
    private
    
    def builder
      @builder ||= ::ChromeAppEngineRails::Builder.new(Rails.application)
    end

    def send_app_file(version)
      send_file builder.build_file_path(version),
        :filename => "#{builder.config.filename}.crx",
        :type => "application/octet-stream"
    end
    
  end
end