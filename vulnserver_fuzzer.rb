#!/usr/bin/ruby
require 'socket'

#nc the vulnserver and run help to see all commands
commands = ["","HELP","STATS","RTIME","LTIME","SRUN","TRUN","GMON",
            "GDOG"]

fuzz_char = 0x41
commands.each do |cmd|
  puts "#{cmd} #{fuzz_char.chr} * 500"
  fuzz_char+=0x1
end
puts "500 bytes is plenty of room for a reverse tcp shell\n"

s = TCPSocket.new ARGV[0],ARGV[1]
puts s.gets

fuzz_char = 0x41
commands.each do |cmd|
  fuzz = fuzz_char.chr * 500
  fuzz_char+=0x1
  s.puts "#{cmd} #{fuzz}"
  puts s.gets
end
