require "rails_helper"

describe MovieActor do
  let(:movie_actor) { build(:movie_actor) }

  it "can be created" do
    movie_actor.save!
    movie_actor.reload
    assert(movie_actor.persisted?)
    assert(MovieActor == movie_actor.class)
  end
end
