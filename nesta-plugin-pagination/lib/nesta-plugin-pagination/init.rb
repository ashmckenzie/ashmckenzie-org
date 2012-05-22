require 'will_paginate/view_helpers/sinatra'

module Nesta
  module Plugin
    module Pagination
      module Helpers

        class PaginationNicePathsRenderer < WillPaginate::Sinatra::LinkRenderer
          def url(page)
            str = File.join(request.script_name.to_s, request.path_info)
            params = request.GET.merge(param_name.to_s => page.to_s)
            params.update @options[:params] if @options[:params]
            "#{str}/#{build_query(params)}"
          end

           def build_query(params)
            page_key, page_number = params.first
            "#{page_key}/#{page_number}"
          end
        end

        def paginate items
          will_paginate(
            items, 
            previous_label: 'Newer', 
            next_label: 'Older',
            renderer: PaginationNicePathsRenderer
          )
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Pagination::Helpers
  end
end
