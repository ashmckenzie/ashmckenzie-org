require 'will_paginate'
require 'will_paginate/array'
require 'will_paginate/view_helpers/sinatra'

include Sinatra::Toadhopper::Helpers

CONFIG = YAML.load_file('./config/config.yml')

require 'redcloth'

module RedCloth::Formatters::HTML

  def cbimage opts
    group, qualifier, image, link, title = opts[:text].split(/\|/)
    <<-EOS
<p class="image">
  <a href="/attachments/#{group}/#{link}" title="#{title}" rel="#{group}#{qualifier}">
    <img src="/attachments/#{group}/#{image}" title="#{title}" alt="#{title}">
    <span class="title">#{title}</span>
  </a>
</p>        
EOS

  end
end

module Nesta

  class App
    use Rack::Static, :urls => [ "/ashmckenzie" ], :root => "themes/ashmckenzie/public"

    set :airbrake, 
      :api_key => CONFIG['errbit']['api_key'],
      :notify_host => CONFIG['errbit']['host'],
      :filters => /password/

    helpers WillPaginate::Sinatra::Helpers

    # FIXME: move this out into a plugin
    #
    error do
      set_common_variables
      post_error_to_airbrake!
      haml(:error)
    end unless Nesta::App.development? 
  end  

  class Page
    def title
      if metadata('title')
        metadata('title')
      elsif heading
        "#{heading} - #{Nesta::Config.title}"
      elsif abspath == '/'
        Nesta::Config.title
      end
    end
  end
end