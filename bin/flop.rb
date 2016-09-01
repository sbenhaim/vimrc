#!/usr/bin/env ruby
line = STDIN.read
delim = ARGV[0]
start = ARGV[1].to_i
finish = ARGV[2].to_i
regex = Regexp.escape( delim )
line[start..finish] = line[start..finish].sub( /^(.*?)(\s*)#{delim}(\s*)(.*?)$/, "\\4\\2#{delim}\\3\\1" )
print line

