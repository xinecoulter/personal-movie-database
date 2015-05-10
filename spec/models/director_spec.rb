require "rails_helper"

describe Director do
  let(:director) { build(:director) }

  it "can be created" do
    director.save!
    director.reload
    assert(director.persisted?)
    assert(Director == director.class)
  end

  it "can have a name" do
    director = build(:director, name: "Quentin Tarantino")
    director.save!
    assert("Quentin Tarantino" == director.reload.name)
  end
end
