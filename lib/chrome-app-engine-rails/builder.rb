module ChromeAppEngineRails

  class Builder

    attr_accessor :application
    attr_accessor :config

    def initialize(application)
      self.application = application
      self.config = ChromeAppEngineRails.config
      self.config.build_path.gsub! /^\//, ''
      self.config.src_path.gsub! /^\//, ''
      self.config.dev_folder.gsub! /^\//, ''
      self.config.keys.keys.each do |k|
        self.config.keys[k] = self.config.keys[k].gsub /^\//, ''
      end
      self.config.tmp_assets_prefix.gsub! /^\//, ''
    end

    def src_dir
      self.application.root.join self.config.src_path
    end

    def dev_dir
      self.application.root.join self.config.build_path, self.config.dev_folder
    end

    def build_dir
      self.application.root.join self.config.build_path, Rails.env
    end

    def tmp_dir
      self.application.root.join self.config.tmp_path
    end

    def build_file_path(version)
      build_dir.join "v#{version}.crx"
    end

    ###

    def rebuild_tmp_dir
      FileUtils.remove_dir tmp_dir, true
      FileUtils.mkdir tmp_dir
    end
    def clean_tmp_dir
      FileUtils.remove_dir tmp_dir, true
    end

    def rebuild_dev_dir
      FileUtils.remove_dir dev_dir, true
      FileUtils.mkdir dev_dir
    end

    def build_assets
      tmp_assets_dir = tmp_dir.join 'assets'
      puts "===> build assets -> #{tmp_assets_dir}"

      FileUtils.remove_dir tmp_assets_dir, true
      FileUtils.mkdir tmp_assets_dir
      self.config.assets.each do |f|
        output_path = tmp_assets_dir.join f
        FileUtils.mkdir_p File.dirname(output_path)
        FileUtils.cp self.application.root.join("public", self.config.tmp_assets_prefix, f), output_path
      end
      FileUtils.remove_dir self.application.root.join("public", self.config.tmp_assets_prefix), true
    end

    def rebuild_dev_assets
      assets_dir = dev_dir.join 'assets'
      puts "===> build assets -> #{assets_dir}"

      FileUtils.remove_dir assets_dir, true
      FileUtils.mkdir assets_dir
      self.config.assets.each do |f|
        output_path = assets_dir.join f
        FileUtils.mkdir_p File.dirname(output_path)
        cmd = "curl '#{self.config.dev_host}/#{self.application.config.assets.prefix}/#{f}' > #{output_path}"
        puts cmd
        system cmd
      end
    end

    def build_resources
      tmp_resources_dir = tmp_dir.join 'resources'
      puts "===> build resources -> #{tmp_resources_dir}"
      
      FileUtils.cp_r src_dir.join('resources'), tmp_resources_dir
    end

    def rebuild_dev_resources
      resources_dir = dev_dir.join 'resources'
      puts "===> build resources -> #{resources_dir}"
      
      FileUtils.remove_dir resources_dir, true
      FileUtils.cp_r src_dir.join('resources'), resources_dir
    end

    def rebuild_dev_manifest
      _build_manifest dev_dir.join('manifest.json')
    end

    def build_manifest
      _build_manifest tmp_dir.join('manifest.json')
    end

    def _build_manifest(output_path)
      puts "===> build manifest -> #{output_path}"
      
      manifest = YAML::load(File.open(src_dir.join('manifest.yml')))
      manifest['version'] = self.config.version
      manifest['update_url'] = self.application.routes.url_helpers.chrome_app_updates_url(
        host: self.config.host,
        format: :xml
      )
      manifest['web_accessible_resources'] = (
        Dir.glob( src_dir.join('resources/**/*') )
      ).map do |f|
        f.gsub (src_dir.to_s.gsub(/\/?$/,'')+'/'), ""
      end
      f = File.new output_path, "w"
      f.write JSON::pretty_generate(manifest)
      f.close
    end

    def build_file
      key_file = self.application.root.join self.config.keys[Rails.env]
      cmd = "chromium-browser --pack-extension='#{tmp_dir}' --pack-extension-key='#{key_file}'"
      puts cmd
      system cmd
      
      FileUtils.mv "#{tmp_dir.to_s.gsub(/\/$/, '')}.crx", build_file_path(self.config.version)
    end

  end

end