#!/usr/bin/env ruby

require 'awesome_print'
require 'pry'

regexs = [
  /^title: .+$/,
  /^layout:.*$/,
  /^tags:.*$/,
  /^---/
]

re = Regexp.union(regexs)

ARGV.each do |file|
  year, month, day = file.scan(/^(\d{4})-(\d{2})-(\d{2})/)[0]
  date = Time.new year, month, day
  contents = ''

  File.open(file, 'r') do |f|
    contents = f.read

    flag_replacement = 'Country: \1'

    m = contents.match(/title: (.+)/)

    if m && title = m[1]
      flag_replacement += "\n\nh1. #{title}"
    end

    contents = contents.split("\n").reject { |x| x.match(re) }.join("\n")

    contents.gsub!(/^- euro-trip-2010$/, 'Categories: euro-trip-2010')
    contents.gsub!(/^flag: (.+)$/, flag_replacement)
    contents.gsub!(/\/images\/photos\//, '/attachments/')
    contents.gsub!(/!\(image\)/, 'p(image). !')
    contents = "Date: #{date.strftime('%-d %B %Y 00:00:00')}\n" + contents
  end
  
  File.open(file, 'w') do |f|
    f.write contents
  end
end