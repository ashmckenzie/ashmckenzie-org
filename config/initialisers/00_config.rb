require 'hashie'

$CONFIG = Hashie::Mash.new YAML.load_file(File.expand_path('../../deploy.yml', __FILE__))
$APP_CONFIG = $CONFIG.app
