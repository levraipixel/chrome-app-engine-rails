namespace :chrome_app do

  task :watch => :environment do

    require 'listen'

    FileUtils.cd Rails.root.to_s
    builder = ::ChromeAppEngineRails::Builder.new(Rails.application)
    builder.rebuild_dev_dir

    builder.rebuild_dev_assets
    assets_callback = Proc.new do |modified, added, removed|
      builder.rebuild_dev_assets
    end
    assets_listener = Listen.to(
      *builder.application.config.assets.paths.map(&:to_s).select{|p| p.start_with?(builder.application.root.to_s)}
    )
      .latency(0.5)
      .relative_paths(true)
      .change(&assets_callback)
    assets_listener.start(false)

    builder.rebuild_dev_resources
    resources_callback = Proc.new do |modified, added, removed|
      builder.rebuild_dev_resources
    end
    resources_listener = Listen.to( builder.dev_dir.join('resources') )
      .latency(0.5)
      .relative_paths(true)
      .change(&resources_callback)
    resources_listener.start(false)
    
    builder.rebuild_dev_manifest
    manifest_callback = Proc.new do |modified, added, removed|
      if modified.include?('manifest.yml')
        builder.rebuild_dev_manifest
      end
    end
    Listen.to( builder.src_dir )
      .latency(0.5)
      .relative_paths(true)
      .change(&manifest_callback)
      .start

  end

  desc 'build files for chrome app dev'
  task :dev => :environment do

    FileUtils.cd Rails.root.to_s
    builder = ::ChromeAppEngineRails::Builder.new(Rails.application)
    builder.rebuild_dev_dir
    builder.rebuild_dev_assets
    builder.rebuild_dev_resources
    builder.rebuild_dev_manifest

  end

  desc 'build files for chrome app build'
  task :build => :environment do
    
    require 'twitter-bootstrap-utils-rails'

    FileUtils.cd Rails.root.to_s
    builder = ::ChromeAppEngineRails::Builder.new(Rails.application)
    builder.rebuild_tmp_dir

    cmd = "rake assets:precompile:all RAILS_ENV=#{Rails.env} RAILS_GROUPS=assets #{builder.config.chrome_build_env}=true"
    puts cmd
    system cmd
    
    builder.build_assets
    builder.build_resources
    builder.build_manifest
    builder.build_file
    builder.clean_tmp_dir
      
  end

end
