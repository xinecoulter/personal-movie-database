require "rails_helper"

describe MovieDecorator do
  let(:movie) { build_stubbed(:movie).decorate }

  describe "#display_directors" do
    let(:director1) { build(:director, name: "Martin Scorsese") }
    let(:director2) { build(:director, name: "Steven Spielberg") }
    let(:director3) { build(:director, name: "George Lucas") }
    before { movie.directors << director1 << director2 << director3 }
    subject { movie.display_directors }

    it "returns a comma-separated string of the movie's director names" do
      assert("#{director1.name}, #{director2.name}, #{director3.name}" == subject)
    end
  end

  describe "#display_genres" do
    let(:genre1) { build(:genre, name: "Action") }
    let(:genre2) { build(:genre, name: "Adventure") }
    let(:genre3) { build(:genre, name: "Comedy") }
    before { movie.genres << genre1 << genre2 << genre3 }
    subject { movie.display_genres }

    it "returns a comma-separated string of the movie's genre names" do
      assert("#{genre1.name}, #{genre2.name}, #{genre3.name}" == subject)
    end
  end

  describe "#display_writers" do
    subject { movie.display_writers }

    context "when writers is present" do
      let(:movie) { build_stubbed(:movie, writers: ["Tweedle Dee", "Tweedle Dum"]).decorate }
      it "returns a comma-separated string of the movie's writers" do
        assert("Tweedle Dee, Tweedle Dum" == subject)
      end
    end

    context "when writers is not present" do
      it "is nil" do
        assert(subject.nil?)
      end
    end
  end

end
