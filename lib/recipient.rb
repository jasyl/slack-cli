require 'httparty'
require 'dotenv'
Dotenv.load

require_relative 'slack_api_error'

class Recipient

  attr_reader :slack_id

  KEY = ENV["SLACK_TOKEN"]

  def initialize(slack_id)
    @slack_id = slack_id
  end

  def self.get(url, parameters: { token: KEY } )
    response = HTTParty.get(url, query: parameters )
    raise SlackApiError, "Error when getting info from #{url}" unless response['ok']
    return response
  end

  def post(message)
    post_url = "https://slack.com/api/chat.postMessage"
    body = {
        token: KEY,
        text: message,
        channel: slack_id
    }

    begin
    bot_attributes = JSON.parse(File.read("bot-settings.json"))
    body.merge!(bot_attributes)
    rescue JSON::ParserError
    end

    response = HTTParty.post(post_url, body: body)

    raise SlackApiError, "Error when posting #{message}" unless response['ok']
    return "Your message was delivered!"
  end

  def self.list
    raise NotImplementedError, "Call me in a child class"
  end

  def details
    raise NotImplementedError, "Call me in a child class"
  end
end