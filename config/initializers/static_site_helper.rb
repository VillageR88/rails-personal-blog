# Static Site Generation Helper Guide
#
# This application uses static site generation helpers for GitHub Pages:
#
# 1. `static_link_to` (aliased to `link_to`) - For GitHub Pages compatibility
#    - Adds .html extensions to paths
#    - Works with ENV['STATIC_EXPORT'] in production
#
# 2. Helper methods for static sites:
#    - `static_friendly_path` - Converts absolute paths to relative
#    - `static_friendly_url` - Handles URL generation for static sites
#    - `absolute_url` - Creates absolute URLs for static sites
#    - `static_meta_tags` - Ensures meta tags work with static sites
#
# These helpers make the Rails application function properly when exported as static HTML.
