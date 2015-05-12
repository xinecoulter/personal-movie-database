class MoviesController < ApplicationController
  def index
    @movies = current_user.movies
  end

  def new
    if params[:movie]
      @search_results = Imdb::Search.new(movie_params[:search]).movies
    end
    authorize! :create, Movie.new(user: current_user)
  end

  def create
    movie = authorize_with_transaction!(:create) do
      Movie.make(current_user, movie_params)
    end

    if movie.persisted?
      redirect_to movie_path(movie)
    else
      render :new
    end
  end

  def show
    @movie = Movie.find(params[:id])
    authorize! :read, @movie
  end

  def edit
    @movie = Movie.find(params[:id])
    authorize! :update, @movie
  end

  def update
    movie = authorize_with_transaction!(:update) do
      Movie.find_and_update(params[:id], movie_params)
    end
    redirect_to movie_path(movie)
  end

  def destroy
    movie = Movie.find(params[:id])
    authorize! :destroy, movie
    movie.destroy!
    redirect_to authenticated_root_path
  end

private

  def movie_params
    params.require(:movie).permit(:search, :imdb_search_id, :storage_identifier)
  end

end
