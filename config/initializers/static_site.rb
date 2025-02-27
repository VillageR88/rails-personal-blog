# Configuration for static site generation
Rails.application.config.static_routes = {
  # Define routes that should be available as static pages
  # format: controller_name: [actions]
  posts: [:index, :show, :about]
  # Add other controllers and actions as needed
}
