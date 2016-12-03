#!/usr/birn/env ruby

# Error log Parser
# 2016 Dec.
# MAC

# /^\[e?\w{3}\]/
# / / : Regexp
# ^ : starting with
# \[ : escape for [
# e? : optional e
# \w{3} : three letters
# \] : escape for ]

# Open the log file
# @todo optimize with Filel snippet

users   = [] # user ids who produce errors in the logs

begin
  File.open('input/generation_errors.log', 'r') do |file|
    file.readlines.each do |line|
      # splite the line in words by blank spaces
      text = line.split(/\.?\s+/)
      header = text[0]
      if( header =~ /^\[e?\w{3}\]/ )
        # drop anything that is not word
        user = header.gsub!(/\W/,"")
        users << user unless users.include? user
      end
    end
  end
rescue StandardError => ex
  puts "Error: #{ex.to_s}"
end

puts "Users to be notified:#{users.join(",")}"
