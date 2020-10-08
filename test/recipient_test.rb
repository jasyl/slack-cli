require_relative "test_helper"

describe "Recipient class" do
  before do
    @new_recipient = Recipient.new(3432)
  end

  describe "initialize" do
    it "check that recipient has correct id" do
      expect(@new_recipient.slack_id).must_equal 3432
    end
  end

  describe "self.get" do
    it "gets a response from API" do
      VCR.use_cassette("recipient_get") do
        response = Recipient.get("https://slack.com/api/users.list")
        expect(response).must_be_kind_of HTTParty::Response
      end
    end

    it "raises error if API response was bad" do
      VCR.use_cassette("recipient_get") do
        expect{Recipient.get("https://slack.com/api/users.list", parameters: {token: "1234"} )}.must_raise SlackApiError
      end
    end
  end

  describe "self.list" do
    it "raises error if invoked without subclassing" do
      expect {Recipient.list}.must_raise NotImplementedError
    end
  end

  describe "details" do
    it "raises error if invoked without subclassing" do
      @new_recipient = Recipient.new(20020202)
      expect {@new_recipient.details}.must_raise NotImplementedError
    end
  end

  describe "post" do

    it "raises an error if message could not be delivered" do
      VCR.use_cassette("recipient_post") do
        @new_recipient = Recipient.new(20020202)
        expect{@new_recipient.post("message")}.must_raise SlackApiError
      end
    end

    it "rescues an error if the bot-settings.json file is empty" do
      VCR.use_cassette("recipient_post") do
        File.open("bot-settings.json","w") do |f|
          f.write("")
        end
        @new_recipient = Recipient.new("U01BKP9SFK9")
        expect(@new_recipient.post("message")).must_equal "Your message was delivered!"

      end
    end
  end
end