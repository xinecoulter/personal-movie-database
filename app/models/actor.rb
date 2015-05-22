class Actor < ActiveRecord::Base
  has_many :roles
  has_many :movies, through: :roles

  def role_in(movie)
    roles.find_by_movie_id(movie.id)
  end
end
