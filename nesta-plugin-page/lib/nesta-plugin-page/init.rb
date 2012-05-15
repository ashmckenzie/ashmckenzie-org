module Nesta
  module Plugin
    module Page
      module Helpers
        def page_id page
          page.heading.downcase.strip.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Page::Helpers
  end
end