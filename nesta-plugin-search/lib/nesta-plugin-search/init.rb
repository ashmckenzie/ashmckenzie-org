require 'sinatra'
require 'nesta/app'

module Nesta
  module Plugin
    module Search
      module Helpers
        # If your plugin needs any helper methods, add them here...
      end
    end
  end

  class App
    helpers Nesta::Plugin::Search::Helpers

    get '/search' do
      set_common_variables

      @q = params[:q]
      @results = []

      if @q
        index = Ferret::Index::Index.new(:path => './index/articles.idx')
        index.search_each("*: #{@q}") { |id, score| @results  << { :id => id, :score => score, :entry => index[id] } }
      end

      @page = Nesta::Page.load('../../nesta-plugin-search/content/pages/search')
      raise Sinatra::NotFound if @page.nil?
      @title = @page.title
      cache haml(@page.template, :layout => @page.layout)
    end
  end
end
