class MoviesController < ApplicationController
  def index
    @movies = current_user.movies
  end

end
