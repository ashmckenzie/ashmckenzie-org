require 'fileutils'

namespace :search do

  desc 'Index site content'
  task :index do

    require 'nesta'
    require 'tilt'
    require File.join(Gem.loaded_specs['nesta'].full_gem_path, 'lib', 'nesta', 'app')
    require 'action_view'
    include ActionView::Helpers::SanitizeHelper

    final_index_location = './index/articles.idx'

    FileUtils.rm_rf final_index_location

    index = Ferret::Index::Index.new(:path => final_index_location)

    articles = []

    Dir['./content/pages/**/*'].each do |file|
      next if !File.file?(file) || File.open(file) { |x| x.grep(/^Date: .+/) }.empty?
      articles << Pathname.new(file)
    end

    articles.each do |article_path|

      article = Nesta::Page.new(article_path.to_s)

      entry = {
        :title => article.heading.gsub(Regexp.new("- #{Nesta::Config.title}"), ''),
        :path => article.path.gsub(/^\.\/+/, '/'),
        :categories => article.categories.map { |category| { :name => category.title.gsub(Regexp.new("- #{Nesta::Config.title}"), ''), :path => "/#{category.path}" } }.to_json,
        :content => strip_tags(article.to_html)
      }

      index << entry
    end
  end
end
