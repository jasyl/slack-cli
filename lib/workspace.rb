require 'table_print'
require_relative 'user'
require_relative 'channel'

class Workspace

  attr_reader :users, :channels

  def initialize
    @users = User.list
    @channels = Channel.list
  end

  def list(thing_to_print)
    if thing_to_print == "users"
      printable_users = @users.map { |user| { "User Name" => user.username, "Real Name" => user.real_name, "Slack ID" => user.slack_id} }
      return printable_users
    elsif thing_to_print == "channels"
      printable_users = @channels.map { |channel| {"Channel Name" => channel.name, "Member Count" => channel.member_count, "Slack ID" => channel.slack_id, "Topic" => channel.topic} }
      return printable_users
    end
  end

end