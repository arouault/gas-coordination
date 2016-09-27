require "active_support/core_ext/string/inflections"
###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
data.categories.each do |category|
  str = "/categories/#{category.name.parameterize.downcase}"
  puts "Generating page #{str}"
  proxy "/categories/#{category.name.parameterize.downcase}/index.html", "/categories/template.html",
    locals: { category: category }, ignore: true
end
# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, filter_html: true)
    @markdown.render(content)
  end

  def step_markdown(*path_segments)
    segments = path_segments.map { |s| s.to_s.parameterize.underscore }
    markdown File.read(File.join(Dir.pwd, 'source', segments) << '.md')
  rescue Errno::ENOENT => e
    if ENV.fetch('RESCUE_MISSING_FILES', true).to_b
      markdown "> No file found at `source/#{segments.join('/')}.md`"
    else
      raise
    end
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
