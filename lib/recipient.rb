require 'httparty'
require 'dotenv'
Dotenv.load

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
    HTTParty.get(url, query: parameters )
  end

  def self.list
    raise NotImplementedError
  end

end