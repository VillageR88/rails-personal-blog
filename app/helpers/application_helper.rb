module ApplicationHelper
  # Helper for generating GitHub Pages compatible links
  def static_link_to(name, options = {}, html_options = {})
    if Rails.env.production? && ENV['STATIC_EXPORT']
      path = url_for(options)
      path = path.gsub(/\/$/, '/index.html')
      path = path.gsub(/^\//, '')
      path = path.empty? ? 'index.html' : "#{path}.html"
      link_to(name, path, html_options)
    else
      link_to(name, options, html_options)
    end
  end
end
