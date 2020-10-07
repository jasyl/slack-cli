require 'httparty'
require 'dotenv'
Dotenv.load

require_relative 'slack_api_error'

class Recipient

  attr_reader :slack_id
  # GET_BASE_URL = "https://slack.com/api/"
  # MESSAGE_BASE_URL =
  # # child classes will append their own url suffixes
  KEY = ENV["SLACK_TOKEN"]

  def initialize(slack_id)
    @slack_id = slack_id
  end

  def self.get(url, parameters: { token: KEY } )
    response = HTTParty.get(url, query: parameters )
    raise SlackApiError unless response['ok']

    return response
  end

  def self.list
    raise NotImplementedError
  end

  def details
    raise NotImplementedError
  end
end