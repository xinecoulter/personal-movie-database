class MoviesController < ApplicationController
  def index
    @movies = current_user.movies
  end

  def new
    if params[:movie]
      @search_results = Imdb::Search.new(movie_params[:search]).movies
    end
  end

  def create
    movie = Movie.make(current_user, movie_params)

    if movie.valid?
      redirect_to movie_path(movie)
    else
      render :new
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

private

  def movie_params
    params.require(:movie).permit(:search, :imdb_search_id, :storage_identification)
  end

end
