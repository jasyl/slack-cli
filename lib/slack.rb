#!/usr/bin/env ruby
require "dotenv"
require "httparty"
require "pry"
Dotenv.load

def main
  puts "Welcome to the Ada Slack CLI!"
  #workspace = Workspace.new

  # TODO projectdfd

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME

URL = "https://slack.com/api/conversations.list"
KEY = ENV["SLACK_TOKEN"]


response = HTTParty.get(URL, query: { token: KEY } )

binding.pry


