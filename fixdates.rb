#! /usr/bin/env ruby

require 'date'

STDIN.each_line do |line|
	line.strip!

	if m = line.match(/^(.*?)(\d\d\d\d\/\d\d\/\d\d)(.*)$/)
		d = Date.parse(m[2])

		line = m[1] + d.strftime("%a, %b %-d") + m[3]
	end

	puts line

end
