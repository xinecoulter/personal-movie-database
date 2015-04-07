class Movie < ActiveRecord::Base
  belongs_to :user
  has_many :movie_directors
  has_many :directors, through: :movie_directors
  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :movie_actors
  has_many :actors, through: :movie_actors

  attr_accessor :search, :imdb_search_id

end
