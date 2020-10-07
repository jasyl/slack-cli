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
end