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
# @todo use .intern to creat symbols

class ErrorInfo
  attr_accessor :id
  attr_accessor :message

  def initialize(id)
    @id = id
    @message = [] # message to infor the user about the error
  end
end

class ErrorReport

  attr_accessor :user
  attr_accessor :message

  def initialize
    @report = []
    @users = []
  end

  def add_error_info(user)
    @users << user
    @report << ErrorInfo.new(@report.size)
      #puts "[#{@report.size}] Added #{user}"
  end

  def parse_error_log
    begin
      File.open('input/generation_errors.log', 'r') do |file|
        file.readlines.each do |line|
          # ommit usless lines
          if(  line[0] != '_' && line[0] != '^' && line[0] != ' ' )
            # check beginning of the line with [eABC] or [ABC]
            user = line.slice!(/^\[e?\w+\]\s*/)
            # drop anything that is not word
            user.gsub!(/\W/,"") unless user == nil

            if( @users.include? user)
              if line.slice!("Row:") == nil
                line.slice!("Input(zFAS Error Descriptions sheet):")
                @report.last.message << line
              end
            else
              add_error_info(user)
            end
          end
        end
      end
    rescue StandardError => ex
      puts "Error: #{ex.to_s}"
    end
  end

  def show
    puts "Error list log report"
    puts "The following #{@report.size} users have introduced errors in the generation script:"
    puts "#{@users.join(" ")}"
    @report.each do |info|
      puts "User:#{@users[info.id]}:\n#{info.message.join(" ")}"
    end
  end

end

report = ErrorReport.new
report.parse_error_log
report.show
