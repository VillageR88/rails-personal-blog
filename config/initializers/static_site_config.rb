Rails.application.config.static_site = {
  # Base URL for the deployed site (used for generating absolute URLs)
  base_url: ENV['STATIC_SITE_URL'] || '',
  
  # Enable asset fingerprinting for static sites
  fingerprint_assets: true,
  
  # Additional routes to export that might not be covered automatically
  additional_routes: [
    # Format: { path: "/some-path", output: "some-path/index.html" }
  ]
}

# Helper for static site rendering
module StaticSiteHelper
  # Fixes URLs for static site output
  def static_url(path)
    path.start_with?('/') ? path[1..-1] : path
  end
  
  # For image paths in static site
  def static_image_path(source)
    static_url(asset_path(source))
  end
end

# Add the helper to ActionView::Base if we're generating a static site
if defined?(Rails) && Rails.env.production? && ENV['GENERATING_STATIC_SITE']
  ActionView::Base.include(StaticSiteHelper)
end
