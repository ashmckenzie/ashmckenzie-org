include Sinatra::Toadhopper::Helpers

CONFIG = YAML.load_file('./config/config.yml')

module Nesta

  class App
    use Rack::Static, :urls => [ "/ashmckenzie" ], :root => "themes/ashmckenzie/public"

    set :airbrake, 
      :api_key => CONFIG['errbit']['api_key'],
      :notify_host => CONFIG['errbit']['host'],
      :filters => /password/

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