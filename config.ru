require 'bundler/setup'
Bundler.require(:default, :development)

if ENV['RACK_ENV'] == 'production'
  log = File.new(File.expand_path("../log/app.log", __FILE__), "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

use Rack::ConditionalGet
use Rack::ETag
use Stethoscope

require 'nesta/app'

use Rack::Rewrite do
  rewrite %r{(.+)/page/(\d+)$}, '$1?page=$2'
  Nesta::Plugin::Redirect::Helpers::Redirect.pages.each do |r|
    r301 r.old, r.new
  end
end

run Nesta::App
