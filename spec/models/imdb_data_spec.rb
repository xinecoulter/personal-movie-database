require "rails_helper"

describe ImdbData do
  let(:user) { build_stubbed(:user) }
  let(:storage_id) { "Box 2 Slot 22" }
  let(:imdb_id) { 12345 }
  let(:imdb_movie) { double }
  before { Imdb::Movie.stub(:new) { imdb_movie } }

  describe ".new" do
    subject { ImdbData.new(user.id, imdb_id, storage_id) }

    it "invokes Imdb::Movie.new" do
      Imdb::Movie.should_receive(:new).with(imdb_id)
      subject
    end
  end

  describe "#title" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).title }

    it "invokes Imdb::Movie#title" do
      imdb_movie.should_receive(:title)
      subject
    end
  end

  describe "#company" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).company }

    it "invokes Imdb::Movie#company" do
      imdb_movie.should_receive(:company)
      subject
    end
  end

  describe "#length" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).length }

    it "invokes Imdb::Movie#length" do
      imdb_movie.should_receive(:length)
      subject
    end
  end

  describe "#plot" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).plot }

    it "invokes Imdb::Movie#plot" do
      imdb_movie.should_receive(:plot)
      subject
    end
  end

  describe "#plot_summary" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).plot_summary }

    it "invokes Imdb::Movie#plot_summary" do
      imdb_movie.should_receive(:plot_summary)
      subject
    end
  end

  describe "#poster" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).poster }

    it "invokes Imdb::Movie#poster" do
      imdb_movie.should_receive(:poster)
      subject
    end
  end

  describe "#year" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).year }

    it "invokes Imdb::Movie#year" do
      imdb_movie.should_receive(:year)
      subject
    end
  end

  describe "#writers" do
    subject { ImdbData.new(user.id, imdb_id, storage_id).writers }

    it "invokes Imdb::Movie#writers" do
      imdb_movie.should_receive(:writers)
      subject
    end
  end

  describe "#assign_directors" do
    let(:movie) { create(:movie) }
    let(:director_name) { "Francis Ford Coppola" }
    before { imdb_movie.stub(:director) { [director_name] } }
    subject { ImdbData.new(user.id, imdb_id, storage_id).assign_directors(movie) }

    context "when the movie is valid" do
      it "invokes Imdb::Movie#director" do
        imdb_movie.should_receive(:director)
        subject
      end

      it "makes the relationship between the movie and the director" do
        expect { subject }.to change(movie.directors, :count).by(1)
      end

      context "when an instance of Director with the same name does not already exist" do
        it "makes a director" do
          expect { subject }.to change(Director, :count).by(1)
        end
      end

      context "when an instance of Director with the same name already exists" do
        let!(:director) { create(:director, name: director_name) }

        it "does not make a director" do
          expect { subject }.to_not change(Director, :count)
        end
      end
    end

    context "when the movie is not valid" do
      before { movie.stub(:valid?) { false } }
      it "does not invoke Imdb::Movie#director" do
        imdb_movie.should_not_receive(:director)
        subject
      end

      it "does not make a director" do
        expect { subject }.to_not change(Director, :count)
      end
    end
  end

  describe "#assign_actors_and_roles" do
    let(:movie) { create(:movie) }
    let(:actor_name) { "Al Pacino" }
    let(:cast_member_character) { "#{actor_name} => Michael Corleone" }
    before { imdb_movie.stub(:cast_members_characters) { [cast_member_character] } }
    subject { ImdbData.new(user.id, imdb_id, storage_id).assign_actors_and_roles(movie) }

    context "when the movie is valid" do
      it "invokes Imdb::Movie#cast_members" do
        imdb_movie.should_receive(:cast_members_characters)
        subject
      end

      it "makes the role" do
        expect { subject }.to change(Role, :count).by(1)
      end

      context "when an instance of Actor with the same name does not already exist" do
        it "makes an actor" do
          expect { subject }.to change(Actor, :count).by(1)
        end
      end

      context "when an instance of Actor with the same name already exists" do
        let!(:actor) { create(:actor, name: actor_name) }

        it "does not make a actor" do
          expect { subject }.to_not change(Actor, :count)
        end
      end
    end

    context "when the movie is not valid" do
      before { movie.stub(:valid?) { false } }
      it "does not invoke Imdb::Movie#cast_members" do
        imdb_movie.should_not_receive(:cast_members)
        subject
      end

      it "does not make a actor" do
        expect { subject }.to_not change(Actor, :count)
      end
    end
  end

  describe "#asign_genres" do
    let(:movie) { create(:movie) }
    let(:genre_name) { "Drama" }
    before { imdb_movie.stub(:genres) { [genre_name] } }
    subject { ImdbData.new(user.id, imdb_id, storage_id).assign_genres(movie) }

    context "when the movie is valid" do
      it "invokes Imdb::Movie#genres" do
        imdb_movie.should_receive(:genres)
        subject
      end

      it "makes the relationship between the movie and the genre" do
        expect { subject }.to change(movie.genres, :count).by(1)
      end

      context "when an instance of Genre with the same name does not already exist" do
        it "makes a genre" do
          expect { subject }.to change(Genre, :count).by(1)
        end
      end

      context "when an instance of Genre with the same name already exists" do
        let!(:genre) { create(:genre, name: genre_name) }

        it "does not make a genre" do
          expect { subject }.to_not change(Genre, :count)
        end
      end
    end

    context "when the movie is not valid" do
      before { movie.stub(:valid?) { false } }
      it "does not invoke Imdb::Movie#genres" do
        imdb_movie.should_not_receive(:genres)
        subject
      end

      it "does not make a genre" do
        expect { subject }.to_not change(Genre, :count)
      end
    end
  end

  describe "#convert_to_movie" do
    let(:movie) { create(:movie) }
    let(:title) { "Casino Royale" }
    let(:company) { "MGM" }
    let(:length) { 140 }
    let(:plot) { "James Bond!" }
    let(:plot_summary) { "James Bond has 00 status." }
    let(:poster) { "cool james bond poster" }
    let(:year) { 2007 }
    let(:writer_name) { "Some Guy" }
    let(:character) { "Daniel Craig => James Bond" }
    let(:director_name) { "Frank Darabont" }
    let(:actor_name) { "Daniel Craig" }
    let(:genre_name) { "Action" }
    before do
      imdb_movie.stub(:title) { title }
      imdb_movie.stub(:company) { company }
      imdb_movie.stub(:length) { length }
      imdb_movie.stub(:plot) { plot }
      imdb_movie.stub(:plot_summary) { plot_summary }
      imdb_movie.stub(:poster) { poster }
      imdb_movie.stub(:year) { year }
      imdb_movie.stub(:writers) { [writer_name] }
      imdb_movie.stub(:cast_members_characters) { [character] }
      imdb_movie.stub(:director) { [director_name] }
      imdb_movie.stub(:cast_members) { [actor_name] }
      imdb_movie.stub(:genres) { [genre_name] }
    end
    subject { ImdbData.new(user.id, imdb_id, storage_id).convert_to_movie }

    it "makes a new movie" do
      expect { subject }.to change(Movie, :count).by(1)
    end

    it "gives the movie the specified attributes" do
      movie = subject
      assert(user.id == movie.user_id)
      assert(imdb_id == movie.imdb_identifier)
      assert(storage_id == movie.storage_identifier)
    end

    it "gives the movie its IMDB attributes" do
      movie = subject
      assert(title == movie.title)
      assert(company == movie.company)
      assert(length == movie.length)
      assert(plot == movie.plot)
      assert(plot_summary == movie.plot_summary)
      assert(poster == movie.poster)
      assert(year == movie.year)
      assert([writer_name] == movie.writers)
    end

    it "gives the movie a director or directors" do
      movie = subject
      assert(director_name == movie.directors.first.name)
    end

    it "gives the movie an actor or actors" do
      movie = subject
      assert(actor_name == movie.actors.first.name)
    end

    it "gives the movie a genre or genres" do
      movie = subject
      assert(genre_name == movie.genres.first.name)
    end
  end
end
