require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

namespace :attachments do

  desc 'Sync attachments'
  task :sync do
    host = "#{CONFIG['deploy']['ssh_user']}@#{CONFIG['deploy']['ssh_host']}"
    path = "#{CONFIG['deploy']['base']}/#{CONFIG['app']['name']}/shared/attachments/"
    cmd = "rsync -vax content/attachments/ #{host}:#{path}"
    puts cmd
    system cmd
  end
end