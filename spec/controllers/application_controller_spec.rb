require "rails_helper"

describe ApplicationController do
  include Devise::TestHelpers

  let(:user) { create(:user) }
  before { sign_in user }

  describe "#authorize_with_transaction!" do
    let(:the_movie) { build(:movie, user: user) }
    before { Movie.stub(:make) { the_movie } }
    subject {
      controller.authorize_with_transaction!(:create) do
        Movie.make(user, attributes_for(:movie))
      end
    }

    it "opens a transaction" do
      ActiveRecord::Base.should_receive(:transaction)
      subject
    end

    context "when the yield raises an exception" do
      before { Movie.stub(:make).and_raise(Exception) }
      it "re-raises the exception" do
        assert_raises(Exception) { subject }
      end
    end

    context "when the yield returns an object" do
      it "checks authorization" do
        controller.should_receive(:authorize!).with(:create, the_movie)
        subject
      end

      context "when the authorization succeeds" do
        it "returns the object" do
          assert(the_movie == subject)
        end
      end

      context "when the authorization fails" do
        let(:other_user) { create(:user) }
        before { Movie.stub(:make) { build(:movie, user: other_user) } }
        it "raises an AccessDenied exception" do
          assert_raises(CanCan::AccessDenied) { subject }
        end
      end
    end
  end

end
