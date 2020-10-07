require_relative "test_helper"

describe "Channel class" do
  describe "initialize" do
    it "makes a channel with correct attributes" do
      @fake_channel = Channel.new(2398, "boats", "just some pictures of boats", 1000)

      expect(@fake_channel).must_be_kind_of Channel
      expect(@fake_channel.slack_id).must_equal 2398
      expect(@fake_channel.name).must_equal "boats"
      expect(@fake_channel.topic).must_equal "just some pictures of boats"
      expect(@fake_channel.member_count).must_equal 1000
    end

    it "raises an error if passed any bad information" do
      expect { Channel.new(nil, "mistake", "place for messing up", 1) }.must_raise SlackApiError
    end
  end

  describe "self.list" do
    it "check the first channel in the list is accurate" do
      VCR.use_cassette("channel_get") do
        first_channel = Channel.list.first
        expect(first_channel.name).must_equal "random"
        expect(first_channel.slack_id).must_equal "C01BKP67695"
        expect(first_channel.member_count).must_equal 3
      end
    end

    it "check that self.list returns the correct number of elements" do
      VCR.use_cassette("channel_get") do
        expect(Channel.list.length).must_equal 3
      end
    end
  end
end