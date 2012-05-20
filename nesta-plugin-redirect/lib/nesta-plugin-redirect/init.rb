module Nesta
  module Plugin
    module Redirect
      module Helpers
        class Redirect
          def self.pages_with_redirect
            Nesta::Page.find_all.select do |page|
              page.metadata('redirect')
            end
          end
        end
      end
    end
  end

  class App
    helpers Nesta::Plugin::Redirect::Helpers
  end
end