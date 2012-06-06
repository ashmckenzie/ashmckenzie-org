require 'recursive_open_struct'

$CONFIG = RecursiveOpenStruct.new YAML.load_file(File.expand_path('../../config.yml', __FILE__))
$APP_CONFIG = $CONFIG.app