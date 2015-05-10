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
end
