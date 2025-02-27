# Configuration for static site generation
if Rails.env.production? && ENV['STATIC_EXPORT']
  ENV['GENERATING_STATIC_SITE'] = 'true'
  
  # Set the base URL for the static site - override with actual domain in production
  ENV['STATIC_SITE_URL'] ||= 'https://github.com/VillageR88/rails-personal-blog'
  
  # Disable features that don't work well with static sites
  Rails.application.config.action_controller.perform_caching = true
  
  # Additional static site configurations can be added here
end

Rails.application.config.static_routes = {
  # Define routes that should be available as static pages
  # format: controller_name: [actions]
  posts: [:index, :show, :about, :blog, :newsletter]
  # Add other controllers and actions as needed
}