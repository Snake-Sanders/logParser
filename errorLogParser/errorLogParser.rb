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

class ErrorReport

  def initialize
    @report = []
    @users = []
  end

  class ErrorInfo

    def initialize(id)
      @id = id
      @message = [] # message to infor the user about the error
    end

    def get_user
      return @user # user ids who produce errors in the logs
    end

    def get_message
      return @message
    end
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
          # splite the line in words by blank spaces
          text = line.split(/\.?\s+/)
          header = text[0]
          if( header =~ /^\[e?\w{3}\]/ )
            # drop anything that is not word
            user = header.gsub!(/\W/,"")
            if( @users.include? user)
              @report.last.message << text[2] unless text[1] = "Row:"
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
    puts "Users to be notified:"
    @report.each do |info|
      puts "User:#{info.get_user}\n"
     puts "Info:#{info.get_message}"
    end
  end

end

report = ErrorReport.new
report.parse_error_log
report.show
