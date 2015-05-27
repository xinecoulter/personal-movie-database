class Movie < ActiveRecord::Base
  belongs_to :user
  has_many :movie_directors
  has_many :directors, through: :movie_directors
  has_many :movie_genres
  has_many :genres, through: :movie_genres
  has_many :roles
  has_many :actors, through: :roles

  validates_uniqueness_of :storage_identifier, scope: :user_id

  attr_accessor :imdb_search_id

  def self.make(user, params)
    imdb_id = params[:imdb_search_id]
    imdb_data = ImdbData.new(user.id, imdb_id, params[:storage_identifier])
    imdb_data.convert_to_movie
  end

  def self.find_and_update(id, params)
    movie = find(id)
    movie.update(params)
    movie
  end
end
