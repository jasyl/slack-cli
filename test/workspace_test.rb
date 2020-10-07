require_relative "test_helper"

describe "Workspace" do
  describe "initialize" do
    it "makes a workspace with the correct variables" do
      VCR.use_cassette("workspace_get") do
        @fake_workspace = Workspace.new

        expect(@fake_workspace).must_be_instance_of Workspace
        expect(@fake_workspace.users).must_be_instance_of Array
        expect(@fake_workspace.channels).must_be_instance_of Array
      end
    end
  end
  
  describe "list" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end
    it "check first user in workspace.users is correct" do
        first_user = @workspace.users.first
        expect(first_user.username).must_equal "slackbot"
        expect(first_user.slack_id).must_equal "USLACKBOT"
        expect(first_user.status_text).must_equal ""
        expect(first_user.status_emoji).must_equal ""
        expect(first_user.real_name).must_equal "Slackbot"
    end
    
    it "check count of users in workspace is accurate" do
        expect(@workspace.users.length).must_equal 5
    end

    it "check that the users are an instance of User" do
      @workspace.users.each do |user|
        expect(user).must_be_kind_of User
      end
    end

    it "check first channel in workspace.channels is correct" do
      first_channel = @workspace.channels.first
      expect(first_channel.name).must_equal "random"
      expect(first_channel.slack_id).must_equal "C01BKP67695"
      expect(first_channel.member_count).must_equal 3
    end

    it "check count of channels in workspace is accurate" do
      expect(@workspace.channels.length).must_equal 3
    end

    it "check that the channels are an instance of Channel" do
      expect(@workspace.channels.first).must_be_instance_of Channel
    end
  end
end