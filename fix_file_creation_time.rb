# Modifies all the times for files in a directory starting with "GOPR" by a specified offset
# The idea is to process files which were taken on a camera with the incorrect time
# Come up with offset by comparing time on the file to the known actual time it occurred

# Only tested on Mac OS X
# usage:
# $ cd target_directory
# $ ruby ~/sek_scripts/fix_file_creation_time.rb

# to get the gem:  gem install activesupport
require 'active_support/time'

files = Dir.entries('.').select{|i| i.start_with? 'GOPR'}

files.each { |file|
  # get the time of the file
  time=Time.at(`stat -f %B #{file}`.to_i)

  # One file was showing created at: 11/20/2010 1:30am but I had call history that showed it was really: 2/1/2016 12:40pm

  newtime = time.advance(:years => 5, :months => 2, :days => 12, :hours => 11, :minutes => 8)
  print "updating time of #{file} from #{time} to #{newtime}\n"

  # File.utime doesn't change the creation time - just modified time
  # File.utime(newtime, newtime, file)

  # Format from SetFile docs: mm/dd/[yy]yy [hh:mm:[:ss] [AM | PM]
  command="SetFile -d '#{newtime.strftime "%m/%d/%Y %H:%M:%S"}' #{file}"
  # print command+"\n"
  system command
}
