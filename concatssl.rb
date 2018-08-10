#!/usr/bin/env ruby

# This tool will concat certificate files ending in .crt
# until it finds a match for the csr file.

require 'open3'

DEBUG = false

class String
  def colorize(color_code); "\e[#{color_code}m#{self}\e[0m"; end
  def red; colorize(31); end
  def green; colorize(32); end
end

def error(e)
  if e.size > 0
    puts e.red
    exit(0)
  end
end

csr = ARGV[0] || 'client.key'
crt = ARGV[1] || 'client.crt'

if File.file?(crt)
  print "The certificate file already exists. Overwrite? (y/n) "
  res = STDIN.gets.chomp
  if res == 'y'
    `rm client.crt`
  else
    puts 'Exiting.'
    exit(0)
  end
end

cmd_csr = %{openssl rsa -noout -modulus -in #{csr} | openssl md5}
out1, err1, status1 = Open3.capture3(cmd_csr)
error(err1)
puts %{CSR OK.}.green

# Read all files in directory
cert_files = Dir['*.crt']
cert_files = cert_files.map do |file|
  File.read(file)
end

cmd_crt = %{openssl x509 -noout -modulus -in #{crt} | openssl md5}
out2 = nil
cert_files.permutation.each do |combo|
  File.open('./client.crt', 'w'){|f| f.write(combo.join("\n"))}
  out2, err2, status2 = Open3.capture3(cmd_crt)
  if out2 == out1
    puts "CRT OK.".green
    break
  end
end

puts "CSR OUTPUT: #{out1}" if DEBUG
puts "CRT OUTPUT: #{out2}" if DEBUG

if out1 === out2
  puts "MATCH! Certificate written to #{crt}".green
else
  puts "NO MATCH.".red
end
