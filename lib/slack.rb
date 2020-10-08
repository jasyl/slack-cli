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

  options = "\nWhat would you like to do?\n— list users\n— list channels\n— select user\n— select channel\n— details\n- send message\n- customize bot\n— quit\n".colorize(:light_green)

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
    when "select user"
      puts "please enter user slack ID or username"
      input = gets.chomp
      looked_for_user = workspace.select("user", input: input)
      if looked_for_user
        puts "you have selected #{looked_for_user.username}"
      else
        puts "we could not find that user"
      end
    when "select channel"
      puts "please enter channel slack ID or name"
      input = gets.chomp
      looked_for_channel = workspace.select("channel", input: input)
      if looked_for_channel
        puts "you have selected #{looked_for_channel.name}"
      else
        puts "we could not find that channel"
      end
    when "details"
      puts workspace.details
    when "send message"
      if workspace.is_selected?
        puts "what message would you like to send?"
        text = gets.chomp
        puts workspace.send_message(text)
      else
        puts workspace.send_message("I didn't pick a user/channel D:")
      end
    when "customize bot"
      puts "what would you like to name the bot?"
      username = gets.chomp
      puts "what emoji would you like to give the bot?"
      emoji = gets.chomp
      workspace.customize_bot(username, emoji)
      puts "enjoy your power to change the names and faces of others"
    when "quit"
      break
    else
      puts "I told you your options, buddy... try again.".colorize(:light_magenta)
    end
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME

# TODO look into soft wrap or continue on new line for table_print