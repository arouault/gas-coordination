require 'middleman-gh-pages'
require 'yaml'
require 'active_support/core_ext/string/inflections'

namespace :generate do

  task :action_steps do

  end

  task :story do
    puts "----> Generating story files"
    data = YAML.load_file File.join(Dir.pwd, 'data', 'story.yml')
    data.each do |title|
      filename = title.to_s.downcase.parameterize
      path = File.join(Dir.pwd, 'source', 'story', 'content', "#{filename}.html.haml")
      unless File.exists? path
        File.open(path, 'w') { |f| f.write starter_content(path) }
        puts "\tGenerated story file at #{path}"
      end
    end
  end

  def starter_content(path)
    ".row\n  %h1 Find me in /#{path.partition('source').last(2).join}"
  end

end
