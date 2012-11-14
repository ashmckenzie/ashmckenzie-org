require 'bundler/setup'
Bundler.require(:default, :development)

Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }

Dir['**/*.rake'].each { |file| load(file) }

namespace :attachments do

  desc 'Sync attachments'
  task :sync do
    host = "#{$CONFIG.deploy.ssh_user}@#{$CONFIG.deploy.ssh_host}"
    path = "#{$CONFIG.deploy.base}/#{$APP_CONFIG.name}/shared/attachments/"
    [
      "rsync -vax content/attachments/ #{host}:#{path}",
      "rsync -vax #{host}:#{path} content/attachments/"
    ].each do |cmd|
      puts cmd
      system cmd
    end
  end
end
