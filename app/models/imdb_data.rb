class ImdbData
  def initialize(imdb_id)
    @data = Imdb::Movie.new(imdb_id)
  end

  def title
    @data.title
  end

  def company
    @data.company
  end

  def length
    @data.length
  end

  def plot
    @data.plot
  end

  def plot_summary
    @data.plot_summary
  end

  def poster
    @data.poster
  end

  def year
    @data.year
  end

  def writers
    @data.writers
  end

  def characters
    @data.cast_members_characters
  end

  def save_directors(movie)
    @data.director.each do |director|
      movie.directors << Director.find_or_create_by!(name: director)
    end
  end

  def save_actors(movie)
    @data.cast_members.each do |actor|
      movie.actors << Actor.find_or_create_by!(name: actor)
    end
  end

  def save_genres(movie)
    @data.genres.each do |genre|
      movie.genres << Genre.find_or_create_by!(name: genre)
    end
  end

  def convert_to_movie(movie)
    ActiveRecord::Base.transaction do
      movie.title = title
      movie.company = company
      movie.length = length
      movie.plot = plot
      movie.plot_summary = plot_summary
      movie.poster = poster
      movie.year = year
      movie.writers = writers
      movie.characters = characters
      movie.save

      save_directors(movie)
      save_actors(movie)
      save_genres(movie)
    end
    movie
  end
end
