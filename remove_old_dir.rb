#!/usr/bin/ruby
require 'fileutils'

date = Time.new.strftime("%d-%m-%y")
puts date

dirs = []
c=0
Dir.entries("/backups/folder/.").sort.each do |x|
        dirs[c]="#{x}"
        c +=1
end
#print dirs
dirs.delete(".") 
dirs.delete("..")
#Do not miss above two lines or script will remove all the contents of current and previous directory.

puts dirs

FileUtils.chdir "/backups/folder" do

dirs.each do |y|
        puts Time.new - File.stat("#{y}").mtime
        if (Time.new - File.stat("#{y}").mtime) > 750 //This value is in seconds//
                FileUtils.remove_dir("#{y}", force = true)
        end
end
end
~
