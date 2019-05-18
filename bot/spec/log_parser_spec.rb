require "./lib/log_parser"

RSpec.describe "Log Parser" do
  context "Public methods" do
    it "Matches are added to the array" do
      games = { "starbound" => [], "rust" => [] }
      log_parser = LogParser.new(games)
      log_parser.parse()
      expect(log_parser.players.first).not_to be_empty
    end
    it "Clears the player array when reset is called" do
      games = { "starbound" => ["test", "test123"], "rust" => ["testing"] }
      log_parser = LogParser.new(games)
      log_parser.reset()
      expect(log_parser.players.first.last).to be_empty # oof
    end
  end
end
