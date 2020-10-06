require 'httparty'
require 'dotenv'
Dotenv.load

require_relative 'recipient'

class User < Recipient

  attr_reader :username, :real_name, :status_text, :status_emoji

  BASE_URL = "https://slack.com/api/users.list"

  def initialize(slack_id, username, real_name, status_text, status_emoji)
    super(slack_id)
    @username = username
    @real_name = real_name
    @status_text = status_text
    @status_emoji = status_emoji
  end

  def self.list
    response = self.get(BASE_URL)
    all_our_pretty_users = []
    response["members"].each_with_index do |user|
      slack_id = user["id"]
      username = user["name"]
      real_name = user["real_name"]
      status_text = user["profile"]["status_text"]
      status_emoji = user['profile']['status_emoji']
      all_our_pretty_users << User.new(slack_id, username, real_name, status_text, status_emoji)
    end
    return all_our_pretty_users
  end
end