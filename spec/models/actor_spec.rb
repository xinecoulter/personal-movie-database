require "rails_helper"

describe Actor do
  let(:actor) { build(:actor) }

  it "can be created" do
    actor.save!
    actor.reload
    assert(actor.persisted?)
    assert(Actor == actor.class)
  end

  it "can have a name" do
    actor = build(:actor, name: "Benedict Cumberbatch")
    actor.save!
    assert("Benedict Cumberbatch" == actor.reload.name)
  end

  describe "#role_in" do
    let(:movie){create(:movie)}
    subject{actor.role_in(movie)}
    context "when the actor has a role in a movie" do
      let(:role){create(:role, actor: actor, movie: movie)}
      it "returns the role" do
        assert(role == subject)
      end
    end
    context "when the actor has no role in a movie" do
      it "returns false" do
        assert(subject.nil?)
      end
    end
  end
end
