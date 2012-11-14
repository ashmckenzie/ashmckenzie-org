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

namespace :content do

  desc 'Create a new page'
  task :new_page do
    print "What is the title of your new post? >> "

    title = STDIN.gets.chomp
    filename = File.join('content', 'pages', "#{title.downcase.gsub(/[^a-z\s]/i, '').gsub(/\s+/, '-')}.textile")

    raise 'Cannot create post as it already exists!' if File.exist?(filename)

    today = Date.today.strftime('%d %B %Y 00:00:00')

    content = <<-EOS
Date: #{today}
Flags: draft
Categories: fillmein

h1. #{title}

Content here

EOS

    File.open(filename, 'w') do |f|
      f.write content
    end
  end
end
