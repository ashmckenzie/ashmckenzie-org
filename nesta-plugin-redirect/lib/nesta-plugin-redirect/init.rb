require 'rack/rewrite'
            
module Nesta
  module Plugin
    module Redirect
      module Helpers
        class Redirect
          def self.pages
            pages = Nesta::Page.find_all.select { |p| p.metadata('redirect') }
            pages.collect do |page|
              OpenStruct.new(old: page.metadata('redirect'), new: "/#{page.path}")
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