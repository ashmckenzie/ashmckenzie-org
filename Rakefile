require 'bundler/setup'
Bundler.require(:default, :development)

Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }

Dir['**/*.rake'].each { |file| load(file) }

namespace :attachments do

  desc 'Sync attachments'
  task :sync do
    host = "#{$CONFIG.deploy.ssh_user}@#{$CONFIG.deploy.ssh_host}"
    path = "#{$CONFIG.deploy.base}/#{$APP_CONFIG.name}/shared/attachments/"
    cmd = "rsync -vax content/attachments/ #{host}:#{path}"
    puts cmd
    system cmd
  end
end
