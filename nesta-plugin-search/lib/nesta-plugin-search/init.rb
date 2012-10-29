require 'json'

module Nesta
  module Plugin
    module Search
      module Helpers

        def search q
          index = Ferret::Index::Index.new(:path => './index/articles.idx')
          results = []
          index.search_each("*: #{q}") do |id, score|
            entry = {
              :title => index[id][:title],
              :path => index[id][:path],
              :categories => JSON.parse(index[id][:categories], { :symbolize_names => true })
            }
            results << { :id => id, :score => score.round(2), :entry => entry }
          end

          results
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Search::Helpers
  end
end
