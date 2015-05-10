require "rails_helper"

describe MovieDirector do
  let(:movie_director) { build(:movie_director) }

  it "can be created" do
    movie_director.save!
    movie_director.reload
    assert(movie_director.persisted?)
    assert(MovieDirector == movie_director.class)
  end
end
