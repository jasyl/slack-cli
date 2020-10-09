require_relative "test_helper"

describe "Workspace" do
  describe "initialize" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "makes a workspace with the correct variables" do
      expect(@workspace).must_be_instance_of Workspace
      expect(@workspace.users).must_be_instance_of Array
      expect(@workspace.channels).must_be_instance_of Array
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

  describe "list" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "returns an array" do
      expect(@workspace.list("users")).must_be_kind_of Array
      expect(@workspace.list("channels")).must_be_kind_of Array
    end

    it "returns the correct headers" do
      expect(@workspace.list("channels")).must_include :name
      expect(@workspace.list("channels")).must_include :member_count
      expect(@workspace.list("channels")).must_include :slack_id
      expect(@workspace.list("channels")).must_include :topic

      expect(@workspace.list("users")).must_include :slack_id
      expect(@workspace.list("users")).must_include :real_name
      expect(@workspace.list("users")).must_include :username
    end
  end

  describe "select user/channel" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "returns an instance of user when select user is called" do
      expect(@workspace.select("user", input: "slackbot")).must_be_instance_of User
    end

    it "returns an instance of channel when select channel is called" do
      expect(@workspace.select("channel", input: "random")).must_be_instance_of Channel
    end

    it "returns the channel with name matching input name" do
      expect(@workspace.select("channel", input: "random").name).must_equal "random"
    end

    it "returns the user with name matching input name" do
      expect(@workspace.select("user", input: "slackbot").username).must_equal "slackbot"
    end

    it "returns the channel with correct name when called by id #" do
      expect(@workspace.select("channel", input: "C01BKP67695".downcase).name).must_equal "random"
    end

    it "returns the user with correct name when called by id #" do
      expect(@workspace.select("user", input: "USLACKBOT".downcase).username).must_equal "slackbot"
    end

    it "returns nil if there is no such user" do
      expect(@workspace.select("user", input: "Abed")).must_be_nil
    end

    it "returns nil if there is no such channel" do
      expect(@workspace.select("channel", input: "Greendale")).must_be_nil
    end

    it "assigns the requested user to the @selected instance variable" do
      @workspace.select("user", input: "slackbot")

      expect(@workspace.selected.username).must_equal "slackbot"
      expect(@workspace.selected).must_be_kind_of User
    end

    it "assigns the requested channel to the @selected instance variable" do
      @workspace.select("channel", input: "random")

      expect(@workspace.selected.name).must_equal "random"
      expect(@workspace.selected).must_be_kind_of Channel
    end

    it "returns nil if user does not provide name or slack_id" do
      expect(@workspace.select("user")).must_be_nil
    end
  end

  describe "details" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "catches and appropriately deals with a nil input" do
      output = "Please select user or channel, first."
      expect(@workspace.details).must_equal output
    end

    it "returns a string" do
      output = "Please select user or channel, first."
      @workspace.select("channel", input: "random")
      expect(@workspace.details).must_be_kind_of String
      expect(@workspace.details).wont_equal output
    end
  end

  describe "send message" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end
    
    it "sends message to valid channel" do
      VCR.use_cassette("workspace_post") do
        @workspace.select("channel", input: "random")
        expect(@workspace.send_message("Hello, Random Channel!")).must_equal "Your message was delivered!"
      end
    end

    it "warns user if they didn't select user/channel first" do
      VCR.use_cassette("workspace_post") do
        expect(@workspace.send_message("hedgehog!")).must_equal "Please select user or channel, first."
      end
    end
  end

  describe "is_selected?" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "returns false if workspace does not have a selected recipient" do
      expect(@workspace.is_selected?).must_equal false
    end

    it "returns true if workspace does have a selected recipient" do
      @workspace.select("user", input: "slackbot")
      expect(@workspace.is_selected?).must_equal true
    end
  end

  describe "customize_bot" do
    before do
      VCR.use_cassette("workspace_get") do
        @workspace = Workspace.new
      end
    end

    it "stores the emoji and username it's given in the json file" do
      json = {"icon_emoji" => ":kissing_heart:","username" => "murder_bot"}
      @workspace.customize_bot("murder_bot", ":kissing_heart:")
      expect(JSON.parse(File.read("bot-settings.json"))).must_equal json
    end
  end
end