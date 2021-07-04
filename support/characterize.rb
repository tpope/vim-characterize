#!/usr/bin/env ruby

require 'open-uri'
require 'json'

firsts = {}
lasts = {}
old = File.read('autoload/characterize.vim').sub(/let s:emojis = {.*/m, '')
File.open('autoload/characterize.vim', 'w') do |out|
  out.write old

  emojis = Hash.new { |h, k| h[k] = [] }
  URI.open(ARGV[1] || 'https://api.github.com/emojis') do |f|
    JSON.parse(f.read).each do |(name, img_url)|
      code = img_url[%r{/emoji/unicode/([[:xdigit:]]{4,})\.png(?:\?|$)}, 1]
      next unless code
      emojis[code] << name
    end
  end
  out.puts 'let s:emojis = {'
  emojis.sort_by { |(k, v)| k.to_i(16) }.each do |(code, names)|
    out.puts "      \\ 0x#{code}: [" + names.map { |n| "':#{n}:'" }.join(', ') + '],'
  end
  out.puts "      \\ }"
  out.puts

  out.puts "let s:d = {}"
  out.puts
  URI.open(ARGV.first || 'https://unicode.org/Public/UNIDATA/UnicodeData.txt') do |f|
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
