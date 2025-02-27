namespace :static_export do
  desc "Export Rails app as static HTML files"
  task :generate => :environment do
    require 'fileutils'
    
    # Create output directory
    output_dir = Rails.root.join('public', 'static')
    FileUtils.mkdir_p(output_dir)
    
    # Copy assets
    FileUtils.cp_r(Rails.root.join('public', 'assets'), output_dir)
    
    # Get all routes
    routes = []
    Rails.application.routes.routes.each do |route|
      path = route.path.spec.to_s.gsub(/\(.:format\)/, '')
      next if path.include?(':') # Skip routes with parameters
      next if path.start_with?('/rails/') # Skip Rails internal routes
      next if path.include?('admin') # Skip admin routes
      next if path == '/' # We'll handle root route separately
      
      routes << path if route.verb === "GET"
    end
    
    # Add root route
    routes << '/'
    
    # Generate HTML for each route
    routes.uniq.each do |route|
      begin
        puts "Generating: #{route}"
        controller = Rails.application.routes.recognize_path(route)[:controller]
        action = Rails.application.routes.recognize_path(route)[:action]
        
        # Create directory structure if needed
        if route != '/'
          dir = File.dirname(route)
          unless dir == '/'
            FileUtils.mkdir_p(File.join(output_dir, dir))
          end
        end
        
        # Generate HTML content
        html = ApplicationController.render(
          template: "#{controller}/#{action}",
          layout: 'application'
        )
        
        # Fix asset paths to be relative
        html.gsub!('href="/assets/', 'href="assets/')
        html.gsub!('src="/assets/', 'src="assets/')
        
        # Write the file
        if route == '/'
          File.write(File.join(output_dir, 'index.html'), html)
        else
          File.write(File.join(output_dir, "#{route.delete_prefix('/')}.html"), html)
        end
      rescue => e
        puts "Error generating #{route}: #{e.message}"
      end
    end
    
    puts "Static site generated in #{output_dir}"
  end
end
