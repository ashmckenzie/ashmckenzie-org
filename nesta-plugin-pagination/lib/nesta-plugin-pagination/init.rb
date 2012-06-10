require 'will_paginate/view_helpers/sinatra'

module Nesta
  module Plugin
    module Pagination
      module Helpers
        def paginate items
          page_param_name = :page
          if links = will_paginate(
            items, 
            previous_label: 'Newer', 
            next_label: 'Older',
            param_name: page_param_name
          )
            # argh, why you no cache
            #
            # links.gsub(Regexp.new(/(?:\?|&)(#{page_param_name})=(\d+)/), '/\1/\2')
            links
          else
            ''
          end
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Pagination::Helpers
  end
end
