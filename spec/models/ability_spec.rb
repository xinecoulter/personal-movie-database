require "rails_helper"
require "cancan/matchers"

describe Ability do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  subject(:ability) { Ability.new(user) }

  describe "movies" do
    it "can manage a movie it owns" do
      movie = build(:movie, user: user)
      expect(ability).to be_able_to(:manage, movie)
    end
    it "can't manage a movie it doesn't own" do
      movie = build(:movie, user: other_user)
      expect(ability).to_not be_able_to(:manage, movie)
    end
  end
end
