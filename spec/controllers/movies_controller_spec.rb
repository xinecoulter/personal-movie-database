require "rails_helper"

describe MoviesController do
  include Devise::TestHelpers

  let(:user) { create(:user) }
  before { sign_in user }

  describe "GET 'index'" do
    subject { get :index }

    it "stores the user's movies as @movies" do
      subject
      assert(user.movies == assigns(:movies))
    end

    it "renders the :index template" do
      subject
      expect(response).to render_template :index
    end
  end

  describe "GET 'new'" do
    let(:search) { "Shawshank Redemption" }
    let(:results) { double }
    before do
      Imdb::Search.stub(:new).with(search) { results }
      results.stub(:movies)
    end
    subject { get :new, movie: { search: search } }

    it "renders the :new template" do
      subject
      expect(response).to render_template :new
    end

    it "checks authorization" do
      new_movie = build(:movie)
      Movie.stub(:new) { new_movie }
      controller.should_receive(:authorize!).with(:create, new_movie)
      subject
    end

    context "when params[:movie] is present" do
      it "invokes Imdb::Search.new" do
        Imdb::Search.should_receive(:new).with(search)
        subject
      end

      it "renders the :new template" do
        subject
        expect(response).to render_template :new
      end

      it "checks authorization" do
        new_movie = build(:movie)
        Movie.stub(:new) { new_movie }
        controller.should_receive(:authorize!).with(:create, new_movie)
        subject
      end
    end

    context "when params[:movie] is not present" do
      subject { get :new }

      it "does not invoke Imdb::Search.new" do
        Imdb::Search.should_not_receive(:new)
        subject
      end
    end
  end

  describe "POST 'create'" do
    let(:params) { { imdb_search_id: 24601, storage_identifier: 2 } }
    let(:imdb_movie) { double }
    let(:the_movie) { create(:movie) }
    before do
      ImdbData.stub(:new) { imdb_movie }
      imdb_movie.stub(:convert_to_movie)
    end
    subject { post :create, movie: params }

    it "checks authorization" do
      Movie.stub(:make) { the_movie }
      controller.should_receive(:authorize!).with(:create, the_movie)
      subject
    end

    it "saves the new movie in the database" do
      expect { subject }.to change(Movie, :count).by(1)
    end

    context "with valid attributes" do
      it "sets the flash" do
        subject
        assert("Awesomesauce! Movie successfully added." == flash[:notice])
      end

      it "redirects to the movie show path" do
        subject
        assert_redirected_to movie_path(Movie.first)
      end
    end

    context "with invalid attributes" do
      let!(:movie){create(:movie, storage_identifier: 2)}
      it "sets the flash" do
        subject
        assert("Fail. Try again." == flash[:error])
      end

      it "re-renders the :new template" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET 'show'" do
    let(:movie) { create(:movie, user: user) }
    subject { get :show, id: movie.id }

    it "assigns the requested movie to @movie" do
      subject
      assert(movie == assigns(:movie))
    end

    it "checks authorization" do
      controller.should_receive(:authorize!).with(:read, movie)
      subject
    end

    it "renders the :show template" do
      subject
      expect(response).to render_template(:show)
    end
  end

  describe "GET 'edit'" do
    let(:movie) { create(:movie, user: user) }
    subject { get :edit, id: movie.id }

    it "assigns the requested movie to @movie" do
      subject
      assert(movie == assigns(:movie))
    end

    it "checks authorization" do
      controller.should_receive(:authorize!).with(:update, movie)
      subject
    end

    it "renders the :edit template" do
      subject
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH 'update'" do
    let!(:movie) { create(:movie, storage_identifier: "1", user: user) }
    let(:params) { { storage_identifier: "5" } }
    subject { patch :update, id: movie.id, movie: params }

    it "checks authorization" do
      controller.should_receive(:authorize!).with(:update, movie)
      subject
    end

    context "with valid attributes" do
      it "updates the movie in the database" do
        subject
        assert(params[:storage_identifier] == movie.reload.storage_identifier)
      end

      it "raises an exception when the update is unsuccessful" do
        Movie.stub(:find_and_update).and_raise(Exception)
        assert_raises(Exception) { subject }
      end

      it "sets the flash" do
        subject
        assert("Awesomesauce! Movie successfully updated." == flash[:notice])
      end

      it "redirects to the movie" do
        subject
        assert_redirected_to movie_path(movie)
      end
    end

    context "with invalid attributes" do
      let!(:other_movie){create(:movie, storage_identifier: "5")}
      it "does not update the movie in the database" do
        expect { subject }.to_not change(movie, :storage_identifier)
        assert("5" != movie.reload.storage_identifier)
      end

      it "sets the flash" do
        subject
        assert("Fail. Try again." == flash[:error])
      end

      it "re-renders the :edit template" do
        subject
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:movie) { create(:movie, user: user) }
    subject { delete :destroy, id: movie.id }

    it "checks authorization" do
      controller.should_receive(:authorize!).with(:destroy, movie)
      subject
    end

    it "destroys the movie" do
      expect { subject }.to change(Movie, :count).by(-1)
    end

    it "sets the flash" do
      subject
      assert("Cool beans. Movie successfully deleted." == flash[:notice])
    end

    it "redirects to the authenticated_root_path" do
      subject
      assert_redirected_to authenticated_root_path
    end
  end
end
