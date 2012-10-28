namespace :search do

  desc 'Index site content'
  task :index do

    require 'action_view'
    include ActionView::Helpers::SanitizeHelper

    index = Ferret::Index::Index.new(:path => './index/articles.idx')

    articles = []
    Dir['./content/pages/**/*'].each do |file|
      next if !File.file?(file) || File.open(file) { |x| x.grep(/^Date: .+/) }.empty?
      articles << Pathname.new(file)
    end

    articles.each do |article|

      raw_content = article.read
      headers = YAML::load(raw_content.to_s[0...raw_content.index(/\n\n/)])
      content = raw_content.to_s[(raw_content.index(/\n\n/) + 2)...-1]
      rendered_content = Tilt[article].new { content }.render

      entry = {
        :title => headers.fetch('Title', article.basename.to_s.gsub(article.extname, '').gsub(/-/, ' ').titleize),
        :path => article.to_s.gsub(article.extname, '').gsub(/\.\/content\/pages/, ''),
        :content => strip_tags(content)
      }

      index << entry
    end
  end
end
