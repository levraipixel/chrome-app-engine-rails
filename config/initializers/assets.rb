module Sass
  module Rails
    module Helpers

      [:image, :video, :audio, :javascript, :stylesheet, :font].each do |asset_class|
        class_eval %Q{
          def #{asset_class}_url_with_host(asset)
            builder = ::ChromeAppEngineRails::Builder.new(::Rails.application)
            Sass::Script::String.new("url('http://" + builder.config.host + resolver.#{asset_class}_path(asset.value) + "')")
          end
        }, __FILE__, __LINE__ - 4
      end
      
      class_eval %Q{
        def chrome_resource_url(asset)
          Sass::Script::String.new("url('chrome-extension://__MSG_@@extension_id__/resources/" + asset.value.to_s + "')")
          end
      }, __FILE__, __LINE__ - 3

    end
  end
end
