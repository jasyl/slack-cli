require 'table_print'
require 'json'
require_relative 'user'
require_relative 'channel'


class Workspace

  attr_reader :users, :channels, :selected

  def initialize
    @users = User.list
    @channels = Channel.list
    @selected = nil
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

  def select(recipient_type, input: "")
    if recipient_type == "user"
      @selected = @users.find {|user| user.username.downcase == input.downcase || user.slack_id.downcase == input.downcase }
    elsif recipient_type == "channel"
      @selected = @channels.find {|channel| channel.name.downcase == input.downcase || channel.slack_id.downcase == input.downcase }
    end
    return @selected
  end

  def is_selected?
    return !!@selected
  end

  def details
    return "Please select user or channel, first." unless is_selected?
    return @selected.details
  end

  def send_message(text)
    return "Please select user or channel, first." unless is_selected?
    return @selected.post(text)
  end

  def customize_bot(username, emoji)
    # we format in hash
    body = {
        icon_emoji: emoji,
        username: username
    }
    # save hash to json file
    File.open("bot-settings.json","w") do |f|
      f.write(body.to_json)
    end
  end
end