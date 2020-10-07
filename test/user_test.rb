require_relative "test_helper"

describe "User" do
  describe "initialize" do
    it "makes a user with correct attributes" do
      @fake_user = User.new(2398, "Troy", "Troy Barnes", "on a boat with Levar Burton", ":D")

      expect(@fake_user).must_be_kind_of User
      expect(@fake_user.slack_id).must_equal 2398
      expect(@fake_user.username).must_equal "Troy"
      expect(@fake_user.real_name).must_equal "Troy Barnes"
      expect(@fake_user.status_text).must_equal "on a boat with Levar Burton"
      expect(@fake_user.status_emoji).must_equal ":D"
    end

    it "raises an error if passed any bad information" do
      expect { User.new(2398, nil, "Troy Barnes", "on a boat with Levar Burton", ":D") }.must_raise SlackApiError
    end
  end

  describe "self.list" do
    it "check the first user in the list is accurate" do
      VCR.use_cassette("user_get") do
        first_user = User.list.first
        expect(first_user.username).must_equal "slackbot"
        expect(first_user.slack_id).must_equal "USLACKBOT"
        expect(first_user.status_text).must_equal ""
        expect(first_user.status_emoji).must_equal ""
        expect(first_user.real_name).must_equal "Slackbot"
      end
    end

    it "check that self.list returns the correct number of elements" do
      VCR.use_cassette("user_get") do
        expect(User.list.length).must_equal 5
      end
    end
  end

  describe "details" do
    before do
      @user = User.new("34839", "Name", "Real Name", "status text", ":thumbsup:" )
    end

    it "returns an instance of string" do
      expect(@user.details).must_be_instance_of String
    end

    it "returns accurate details for an specific user" do
      output = "Username: Name\nReal Name: Real Name\nSlack ID: 34839\nStatus: status text\nStatus Emoji: :thumbsup:"
      expect(@user.details).must_equal output
    end
  end
end