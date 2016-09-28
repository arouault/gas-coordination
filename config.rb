Dotenv.load
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
  proxy "/categories/#{category.name.parameterize.downcase}/index.html",
    "/categories/template.html", locals: { category: category }, ignore: true
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
  extend Haml::Helpers

  def link_to(resource_name, resource_or_param, param_name: nil, &block)
    path = path_to(resource_name, resource_or_param, param_name: param_name)
    if block_given?
      haml_tag :a, href: path do
        yield
      end
    else
      haml_tag :a, href: path
    end
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      filter_html: true
    )
    @markdown.render(content)
  end

  def step_markdown(*path_segments)
    filepath = content_file(path_segments)
    markdown File.read(filepath)
  rescue Errno::ENOENT => e
    if ENV.fetch('RESCUE_MISSING_FILES', true).to_b
      markdown "> No file found at `#{filepath}`"
    else
      raise
    end
  end

  def content_file(*path_segments, ext: '.md')
    segments = path_segments.flatten.map { |s| s.to_s.downcase.parameterize.underscore }
    File.join(Dir.pwd, 'source', segments) << ext
  end

  def render_story_file(title)
    filename = title.to_s.downcase.parameterize
    path = File.join(Dir.pwd, 'source', 'story', 'content', "#{filename}.html.haml")
    contents = File.exists?(path) ? File.read(path) : '%h1 Missing content!'
    Haml::Engine.new(contents).render
  end

  def path_to(resource_name, resource_or_param, param_name: nil)
    param_to_use = param_name || :id
    segments = if [String, Fixnum].include?(resource_or_param.class)
      [resource_name, resource_or_param]
    else
      [resource_name, resource_or_param.send(param_to_use)]
    end
    "/" << segments.map { |s| s.to_s.downcase.parameterize }.join('/')
  end

end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
