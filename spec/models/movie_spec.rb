require "rails_helper"

describe Movie do
  let(:movie) { build(:movie) }

  it "can be created" do
    movie.save!
    movie.reload
    assert(movie.persisted?)
    assert(Movie == movie.class)
  end

  it "can have an imdb_identifier" do
    movie = build(:movie, imdb_identifier: 9000)
    movie.save
    assert(9000 == movie.reload.imdb_identifier)
  end

  it "can have a title" do
    movie = build(:movie, title: "Captain America: Winter Soldier")
    movie.save
    assert("Captain America: Winter Soldier" == movie.reload.title)
  end

  it "can have a company" do
    movie = build(:movie, company: "Paramount")
    movie.save
    assert("Paramount" == movie.reload.company)
  end

  it "can have a length" do
    movie = build(:movie, length: 130)
    movie.save
    assert(130 == movie.reload.length)
  end

  it "can have a plot" do
    movie = build(:movie, plot: "some insane plot")
    movie.save
    assert("some insane plot" == movie.reload.plot)
  end

  it "can have a plot_summary" do
    movie = build(:movie, plot_summary: "some stupid plot summary")
    movie.save
    assert("some stupid plot summary" == movie.reload.plot_summary)
  end

  it "can have a poster" do
    movie = build(:movie, poster: "i'm a movie poster!")
    movie.save
    assert("i'm a movie poster!" == movie.reload.poster)
  end

  it "can have a year" do
    movie = build(:movie, year: 1985)
    movie.save
    assert(1985 == movie.reload.year)
  end

  it "can have writers" do
    movie = build(:movie, writers: ["Tina Fey", "Amy Poehler"])
    movie.save
    assert(movie.reload.writers.include? "Tina Fey")
    assert(movie.reload.writers.include? "Amy Poehler")
  end

  it "can have a storage_identifier" do
    movie = build(:movie, storage_identifier: "Box 1 Slot 40")
    movie.save
    assert("Box 1 Slot 40" == movie.reload.storage_identifier)
  end

  it "must have a unique storage_identifier within the user scope" do
    create(:movie, user_id: 1, storage_identifier: "Box 1 Slot 1")
    movie = build(:movie, user_id: 1, storage_identifier: "Box 1 Slot 1")
    other_movie = build(:movie, user_id: 2, storage_identifier: "Box 1 Slot 1")
    assert(movie.invalid?)
    assert(other_movie.valid?)
  end

  describe ".make" do
    let(:user) { create(:user) }
    let(:params) { {imdb_search_id: 9000, storage_identifier: 40} }
    let(:imdb_data) { double }

    before do
      ImdbData.stub(:new) { imdb_data }
      imdb_data.stub(:convert_to_movie)
    end

    subject { Movie.make(user, params) }

    it "invokes ImdbData.new" do
      ImdbData.should_receive(:new).with(user.id, 9000, 40)
      subject
    end
  end

  describe ".find_and_update" do
    let!(:movie) { create(:movie, storage_identifier: 5) }
    let(:params) { {storage_identifier: 10} }
    subject { Movie.find_and_update(movie.id, params) }

    it "finds and updates the task" do
      expect { subject }.to_not change(Movie, :count)
      assert(subject.storage_identifier == params[:storage_identifier])
    end
  end
end
