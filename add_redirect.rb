#!/usr/bin/env ruby

require 'awesome_print'
require 'pry'

ARGV.each do |file|
  year, month, day, file_title = file.scan(/^(\d{4})-(\d{2})-(\d{2})-(.+)\.textile$/)[0]
  date = Time.new year, month, day
  contents = ''

  File.open(file, 'r') do |f|
    contents = f.read
    contents.gsub!(/^(Country: .+)$/, '\1' + "\nRedirect: /#{year}/#{month}/#{day}/#{file_title}")
  end

  File.open(file, 'w') do |f|
    f.write contents
  end
end