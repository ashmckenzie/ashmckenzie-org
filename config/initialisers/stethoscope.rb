require 'stethoscope'

Stethoscope.check :release do |resp|
  resp[:revision] = `git log | head -1`
end