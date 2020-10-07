#!/usr/bin/env ruby
# require "dotenv"
require "httparty"
require "pry"
require "colorize"
require_relative 'workspace.rb'
# Dotenv.load

def main
  puts "Welcome to the Ada Slack CLI!".colorize(:light_yellow)
  workspace = Workspace.new

  #puts load information (number of users and channels, etc)
  puts "There are #{workspace.users.length} users and #{workspace.channels.length} channels".colorize(:light_yellow)

  options = "\nWhat would you like to do?\n— list users\n— list channels\n— quit\n".colorize(:light_green)

  while true
    puts options
    print "=> "
    user_input = gets.chomp.downcase
    puts

    case user_input
    when "list users"
      tp workspace.list("users")
    when "list channels"
      tp workspace.list("channels")
    when "quit"
      break
    else
      puts "I told you your options, buddy... try again.".colorize(:light_magenta)
    end
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME

# URL = "https://slack.com/api/conversations.list"
# KEY = ENV["SLACK_TOKEN"]
# response = HTTParty.get(URL, query: { token: KEY } )


# blah blah as part of code
# if "list users"
# tp workspace.list("users")
# if "list channels"
# tp workspace.list("channels")

# TODO look into soft wrap or continue on new line for table_print