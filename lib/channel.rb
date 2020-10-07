require 'httparty'
require 'dotenv'
Dotenv.load

require_relative 'recipient'

class Channel < Recipient

  attr_reader :name, :topic, :member_count

  BASE_URL = "https://slack.com/api/conversations.list"

  def initialize(slack_id, name, topic, member_count)

    raise SlackApiError if [slack_id, name, topic, member_count].include? nil

    super(slack_id)
    @name = name
    @topic = topic
    @member_count = member_count
  end

  def self.list
    response = self.get(BASE_URL)
    all_our_pretty_channels = []
    response["channels"].each_with_index do |channel|
      slack_id = channel["id"]
      name = channel["name"]
      topic = channel["purpose"]["value"]
      member_count = channel["num_members"]
      all_our_pretty_channels << Channel.new(slack_id, name, topic, member_count)
    end
    return all_our_pretty_channels
  end

  def details
    output = "Name: #{name}\nSlack ID: #{slack_id}\nMember Count: #{member_count}\nTopic: #{topic}"
    return output
  end

end