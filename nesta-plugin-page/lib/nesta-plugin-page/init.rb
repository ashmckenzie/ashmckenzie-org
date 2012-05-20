module Nesta
  module Plugin
    module Page
      module Helpers
        def page_id page
          page.heading.downcase.strip.gsub(/[^\w\s]/, '').gsub(/\s+/, '-') if page && page.heading 
        end

        def paginate items
           will_paginate(items, previous_label: 'Newer', next_label: 'Older')
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Page::Helpers
  end
end