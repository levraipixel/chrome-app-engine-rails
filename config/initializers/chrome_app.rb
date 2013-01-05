builder = ::ChromeAppEngineRails::Builder.new(Rails.application)

Rails.application.config.assets.paths << builder.src_dir.join("assets", "javascripts")
Rails.application.config.assets.paths << builder.src_dir.join("assets", "stylesheets")

if ENV[builder.config.chrome_build_env].to_s == "true" 
  Rails.application.config.assets.compress = true
  Rails.application.config.assets.digest = false
  Rails.application.config.hamlcoffee.uglify = true if Rails.application.config.hamlcoffee
  Rails.application.config.assets.precompile = builder.config.assets
  Rails.application.config.assets.prefix = builder.config.tmp_assets_prefix

  builder.config.on_compile.call(Rails.application.config)
end