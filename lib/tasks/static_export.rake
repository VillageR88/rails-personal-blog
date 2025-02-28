namespace :static_export do
  desc "Generate a complete static version of the site"
  task :generate => :environment do
    require 'fileutils'
    require 'uri'
    
    # Configuration
    output_dir = Rails.root.join('public', 'static')
    host = 'http://localhost:3000'
    
    puts "Starting static site generation to #{output_dir}"
    
    # Ensure output directory exists
    FileUtils.mkdir_p(output_dir)
    
    # Define all routes to be exported
    routes = [
      { path: "/", output: "index.html" },
      { path: "/about", output: "about/index.html" },      
      { path: "/newsletter", output: "newsletter/index.html" }
    ]
    
    # Add blog routes
    if defined?(BlogController)
      puts "Adding blog routes..."
      # For JSON data source
      if File.exist?(Rails.root.join('db', 'data.json'))
        puts "Using data.json for blog content"
        begin
          articles = JSON.parse(File.read(Rails.root.join('db', 'data.json')))
          articles.each do |article|
            routes << { 
              path: "/blog/#{article['slug']}", 
              output: "blog/#{article['slug']}/index.html" 
            }
          end
        rescue => e
          puts "Error loading data.json: #{e.message}"
        end
      # For database source
      elsif defined?(Post)
        puts "Using Post model for blog content"
        begin
          Post.find_each do |post|
            routes << { 
              path: "/blog/#{post.slug}", 
              output: "blog/#{post.slug}/index.html" 
            }
          end
        rescue => e
          puts "Error loading posts from database: #{e.message}"
        end
      end
      
      # Add blog index
      routes << { path: "/blog", output: "blog/index.html" }
    end
    
    # Set up Rails server for rendering
    puts "Setting up Rails for rendering..."
    app = Rails.application
    
    # For each route, fetch and save the HTML
    routes.each do |route|
      puts "Generating: #{route[:output]}"
      
      begin
        # Create the environment for the request
        env = Rack::MockRequest.env_for(
          "#{host}#{route[:path]}",
          'HTTP_HOST' => URI.parse(host).host
        )
        
        # Process the request through the Rails stack
        status, headers, response = app.call(env)
        
        if status >= 200 && status < 300
          # Get response body
          body = ''
          response.each { |part| body << part }
          
          # Calculate path depth to fix relative references
          depth = route[:output].count('/')
          path_prefix = depth > 0 ? "../" * depth : ""
          
          # Fix absolute paths (starting with /)
          body.gsub!(/href="\/(?!\/|http:|https:)/, "href=\"#{path_prefix}")
          body.gsub!(/src="\/(?!\/|http:|https:)/, "src=\"#{path_prefix}")
          body.gsub!(/content="\/(?!\/|http:|https:)/, "content=\"#{path_prefix}")
          
          # Fix relative asset paths that don't have proper depth prefix
          if depth > 0
            # Match references to assets/ that don't already have ../ prefixes
            # Make sure to keep the "assets/" part in the result
            body.gsub!(/href="(?!\/|http:|https:|mailto:|tel:|#|\.\.\/)(assets\/)/, "href=\"#{path_prefix}\\1")
            body.gsub!(/src="(?!\/|http:|https:|\.\.\/)(assets\/)/, "src=\"#{path_prefix}\\1")
            
            # Also handle potential references to images/ or other static folders
            body.gsub!(/href="(?!\/|http:|https:|mailto:|tel:|#|\.\.\/)(images\/)/, "href=\"#{path_prefix}\\1")
            body.gsub!(/src="(?!\/|http:|https:|\.\.\/)(images\/)/, "src=\"#{path_prefix}\\1")
          end
          
          # Make sure directory exists
          file_path = File.join(output_dir, route[:output])
          FileUtils.mkdir_p(File.dirname(file_path))
          
          # Write the file
          File.write(file_path, body)
          puts "  ✓ Successfully generated #{route[:output]}"
        else
          puts "  ✗ Error generating #{route[:path]} (Status: #{status})"
        end
      rescue => e
        puts "  ✗ Exception while generating #{route[:path]}: #{e.message}"
        puts e.backtrace.take(5)
      end
    end
    
    # Copy assets
    assets_source = Rails.root.join('public', 'assets')
    assets_dest = File.join(output_dir, 'assets')
    if Dir.exist?(assets_source)
      puts "Copying assets..."
      FileUtils.mkdir_p(assets_dest)
      FileUtils.cp_r(Dir.glob("#{assets_source}/*"), assets_dest)
      
      # Process CSS files to fix background image URLs
      Dir.glob("#{assets_dest}/**/*.css").each do |css_file|
        content = File.read(css_file)
        content.gsub!(/url\(['"]?([^'")]+)['"]?\)/) do |match|
          url = $1
          "url('/rails-personal-blog#{url}')"
        end
        File.write(css_file, content)
      end
    end
    
    # Copy images if they exist
    images_source = Rails.root.join('public', 'images')
    images_dest = File.join(output_dir, 'images')
    if Dir.exist?(images_source)
      puts "Copying images..."
      FileUtils.mkdir_p(images_dest)
      FileUtils.cp_r(Dir.glob("#{images_source}/*"), images_dest)
    end
    
    # Copy any other required static files
    ['favicon.ico', 'robots.txt', '404.html'].each do |file|
      source = Rails.root.join('public', file)
      if File.exist?(source)
        puts "Copying #{file}..."
        FileUtils.cp(source, File.join(output_dir, file))
      end
    end
    
    puts "Static site generation complete! Files available at: #{output_dir}"
  end
end
