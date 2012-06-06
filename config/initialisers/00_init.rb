$CONFIG = RecursiveOpenStruct.new YAML.load_file('./config/config.yml')
$APP_CONFIG = $CONFIG.app