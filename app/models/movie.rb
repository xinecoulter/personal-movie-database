class Movie < ActiveRecord::Base
  belongs_to :user
  has_many :movie_directors
  has_many :directors, through: :movie_directors
  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :movie_actors
  has_many :actors, through: :movie_actors

  attr_accessor :search, :imdb_search_id

  def self.make(user, params)
    imdb_id = params[:imdb_search_id]
    imdb_data = ImdbData.new(imdb_id)
    movie = Movie.new(
      storage_identification: params[:storage_identification],
      imdb_id: imdb_id
    )
    transaction do
      imdb_data.convert_to_movie(movie)
      user.movies << movie
    end
    movie
  end
end
