class MoviesController < ApplicationController
  def index
    @movies = current_user.movies
  end

  def new
    if params[:movie]
      @search_results = Imdb::Search.new(movie_params[:search]).movies
    end
  end

private

  def movie_params
    params.require(:movie).permit(:search, :imdb_search_id, :storage_identification)
  end

end
