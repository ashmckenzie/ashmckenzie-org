require 'bundler/setup'
Bundler.require(:default, :development)

if ENV['RACK_ENV'] == 'production'
  log = File.new(File.expand_path("../log/app.log", __FILE__), "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

use Rack::ConditionalGet
use Rack::ETag

require 'nesta/env'

Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))

require 'nesta/config'

module Nesta
  class Config
    def self.yaml_path
      File.expand_path('config/nesta.yml', Nesta::App.root)
    end
  end
end

require 'sinatra'
require 'sinatra/toadhopper'
require 'nesta/app'

run Nesta::App