#!/usr/bin/ruby
#
require 'net/scp'

host = ARGV[0]

puts "#{host}"

puts "Enter username "
login = STDIN.gets.chomp

puts "Enter password "
passd = STDIN.gets.chomp

puts "upload/download? "
$choice = STDIN.gets.chomp

#puts "choice is #{$choice}"
puts "Enter local path"
lpath = STDIN.gets.chomp
#puts "local path is #{lpath}"

puts "Enter remote path"
rpath = STDIN.gets.chomp
#puts "remote path is #{rpath}" 


Net::SCP.start(host, login, :password => passd) do | scp |
        if $choice == "upload"
        		puts "starting upload"
                scp.upload(lpath,rpath)
                puts "upload complete"

        elsif $choice == "download"
        		puts "starting download"
                scp.download!(rpath,lpath)
                puts "download complete"
        else
                puts "wrong choice"
        end
end