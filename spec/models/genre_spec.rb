require "rails_helper"

describe Genre do
  let(:genre) { build(:genre) }

  it "can be created" do
    genre.save!
    genre.reload
    assert(genre.persisted?)
    assert(Genre == genre.class)
  end

  it "can have a name" do
    genre = build(:genre, name: "Action")
    genre.save
    assert("Action" == genre.reload.name)
  end
end
