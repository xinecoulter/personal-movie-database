require "rails_helper"

describe MovieGenre do
  let(:movie_genre) { build(:movie_genre) }

  it "can be created" do
    movie_genre.save!
    movie_genre.reload
    assert(movie_genre.persisted?)
    assert(MovieGenre == movie_genre.class)
  end
end
