namespace :static do
  desc "Generate a static site from your Rails app"
  task :generate => :environment do
    include Rails.application.routes.url_helpers
    
    # Create build directory
    build_dir = Rails.root.join('public', 'static_build')
    FileUtils.mkdir_p(build_dir)
    
    # Get controller actions that should be static
    static_pages = [
      { controller: 'posts', action: 'index', path: 'index.html' },
      { controller: 'posts', action: 'about', path: 'about.html' }
      # Add other routes as needed
    ]
    
    # For blog posts, dynamically get all published posts
    Post.published.find_each do |post|
      static_pages << { 
        controller: 'posts', 
        action: 'show', 
        path: "posts/#{post.slug}.html", 
        params: { id: post.id }
      }
    end
    
    # Set up a fake controller environment
    env = {
      "HTTP_HOST" => "localhost",
      "HTTPS" => "off",
      "REQUEST_METHOD" => "GET"
    }
    
    # Generate each page
    static_pages.each do |page|
      puts "Generating: #{page[:path]}"
      
      # Create controller and set params
      controller = "#{page[:controller]}_controller".classify.constantize.new
      controller.request = ActionDispatch::Request.new(env)
      controller.response = ActionDispatch::Response.new
      controller.params = page[:params] || {}
      
      # Call the action and get the response body
      controller.process(page[:action])
      content = controller.response.body
      
      # Make sure directory exists
      file_path = File.join(build_dir, page[:path])
      FileUtils.mkdir_p(File.dirname(file_path))
      
      # Write the file
      File.write(file_path, content)
    end
    
    # Copy assets
    puts "Copying assets..."
    FileUtils.cp_r(Rails.root.join('public', 'assets'), build_dir)
    FileUtils.cp_r(Rails.root.join('public', 'images'), build_dir) if Dir.exist?(Rails.root.join('public', 'images'))
    
    puts "Static site generated in #{build_dir}"
  end
end
