#!/usr/bin/env ruby

require 'open-uri'

firsts = {}
lasts = {}
old = File.read('autoload/characterize.vim')[/.*?\nlet s:d = {}\n*/m]
File.open('autoload/characterize.vim', 'w') do |out|
  out.write old

  open(ARGV.first || 'https://unicode.org/Public/UNIDATA/UnicodeData.txt') do |f|
    f.each_line do |l|
      code, name, cat, ccc, bc, cdm, ddv, dv, nv, m, u1name, comment, ucase, lcase, tcase = *l.chomp.split(';', 15)
      if name =~ /<(.*), First>/
        firsts[$1] = code
      elsif name =~ /<(.*), Last>/
        lasts[$1] = code
      else
        name = u1name if name =~ /</ && !u1name.empty?
        out.puts "let s:d[0x#{code}]='#{name}'"
      end
    end
  end
  out.puts
  out.puts 'let s:ranges = ['
  firsts.each do |desc, first|
    if last = lasts[desc]
      out.puts "      \\ [0x#{first}, 0x#{last}, '<#{desc}>'],"
    end
  end
  out.puts '      \ ]'
end
